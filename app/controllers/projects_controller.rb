require 'net/http'

class ProjectsController < ApplicationController
  include ProjectsHelper

  before_filter :load_project, only: [:show, :edit, :update, :decide_tip_amounts]

  def index
    @projects = Project.order(projects_order).page(params[:page]).per(30)
  end

  def search
    if params[:query].present? && project = Project.find_or_create_by_url(params[:query])
      redirect_to pretty_project_path(project)
    else
      @projects = Project.search(params[:query].to_s).order(projects_order).page(params[:page]).per(30)
      render :index
    end
  end

  def show
    redirect_to_pretty_url

    load_github_repo
    update_project_avatar_url

    update_bitcoin_address
    @project_tips = @project.tips
    @recent_tips  = @project_tips.includes(:user).order(created_at: :desc).first(5)
  end

  def edit
    authorize! :update, @project
  end

  def update
    authorize! :update, @project
    @project.attributes = project_params
    if @project.tipping_policies_text.try(:text_changed?)
      @project.tipping_policies_text.user = current_user
    end
    if @project.save
      redirect_to project_path(@project), notice: I18n.t('notices.project_updated')
    else
      render 'edit'
    end
  end

  def decide_tip_amounts
    authorize! :decide_tip_amounts, @project
    if request.patch?
      @project.available_amount # preload anything required to get the amount, otherwise it's loaded during the assignation and there are undesirable consequences
      percentages = params[:project][:tips_attributes].values.map{|tip| tip['amount_percentage'].to_f}
      if percentages.sum > 100
        redirect_to decide_tip_amounts_project_path(@project), alert: I18n.t('errors.can_assign_more_tips')
        return
      end
      raise "wrong data" if percentages.min < 0
      @project.attributes = params.require(:project).permit(tips_attributes: [:id, :amount_percentage])
      if @project.save
        message = I18n.t('notices.tips_decided')
        if @project.has_undecided_tips?
          redirect_to decide_tip_amounts_project_path(@project), notice: message
        else
          redirect_to @project, notice: message
        end
      end
    end
  end

  private

  def load_project
    if params[:id].present?
      super(params[:id])
    elsif params[:service].present? && params[:repo].present?
      super(
        Project.where(host: params[:service]).
          where('lower(`full_name`) = ?', params[:repo].downcase).first
      )
    end
  end

  def project_params
    params.require(:project).permit(:branch, :disable_notifications, :hold_tips, tipping_policies_text_attributes: [:text])
  end

  def projects_order
    {
      'balance'     => {available_amount_cache: :desc, watchers_count: :desc, full_name: :asc},
      'watchers'    => {watchers_count: :desc, available_amount_cache: :desc, full_name: :asc},
      'repository'  => {full_name: :asc, available_amount_cache: :desc, watchers_count: :desc},
      'description' => {description: :asc, available_amount_cache: :desc, watchers_count: :desc, full_name: :asc}
    }.[](params[:order] || 'balance')
  end

  def redirect_to_pretty_url
    if params[:id].present?
      begin
        respond_to do |format|
          format.html { redirect_to pretty_project_path(@project) }
        end
      rescue ActionController::UnknownFormat
      end
    end
  end
  
  def update_bitcoin_address
    if @project.bitcoin_address.nil?
      blockchain_uri       = URI BLOCKCHAIN_NEW_URL
      blockchain_pass      = CONFIG["blockchain_info"]["password"]
      blockchain_label     = "#{@project.full_name}@tip4commit"
      blockchain_params    = { password: blockchain_pass, label: blockchain_label }
      blockchain_uri.query = URI.encode_www_form blockchain_params
      blockchain_resp      = Net::HTTP.get_response blockchain_uri
      if blockchain_resp.is_a? Net::HTTPSuccess 
        bitcoin_address = (JSON.parse blockchain_resp.body)["address"]
        @project.update_attribute :bitcoin_address, bitcoin_address unless bitcoin_address.nil?
      end
    end
  end

  def load_github_repo
    return if @project.nil?

    github_repo_uri  = URI "#{GITHUBAPI_REPO_URL}/#{@project.full_name}"
    github_repo_resp = Net::HTTP.get_response github_repo_uri
    return unless github_repo_resp.is_a? Net::HTTPSuccess

    github_repo_json = JSON.parse github_repo_resp.body
    return if github_repo_json["id"].nil?

    @github_repo     = github_repo_json
    @github_owner    = @github_repo["owner"]
    @github_org      = @github_repo["organization"]
    @is_organization = !@github_org.nil?
  end

  def update_project_avatar_url
    return if @project.nil? || !@is_organization

    avatar_url   = @github_org["avatar_url"]
    is_unchanged = avatar_url.eql? @project.avatar_url

    @project.update_attribute :avatar_url , avatar_url unless is_unchanged
  end
end
