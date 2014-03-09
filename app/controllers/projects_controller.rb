require 'net/http'

class ProjectsController < ApplicationController

  before_filter :load_project, only: [:show, :edit, :update, :decide_tip_amounts]

  def index
    @projects = Project.order(available_amount_cache: :desc, watchers_count: :desc, full_name: :asc).page(params[:page]).per(30)
  end

  def by_watchers
    @projects = Project.order(watchers_count: :desc, available_amount_cache: :desc, full_name: :asc).page(params[:page]).per(30)
    render "index"
  end

  def show
    if @project.bitcoin_address.nil?
      uri = URI("https://blockchain.info/merchant/#{CONFIG["blockchain_info"]["guid"]}/new_address")
      params = { password: CONFIG["blockchain_info"]["password"], label:"#{@project.full_name}@tip4commit" }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess) && (bitcoin_address = JSON.parse(res.body)["address"])
        @project.update_attribute :bitcoin_address, bitcoin_address
      end
    end
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
      redirect_to project_path(@project), notice: "The project settings have been updated"
    else
      render 'edit'
    end
  end

  def decide_tip_amounts
    authorize! :decide_tip_amounts, @project
    if request.patch?
      @project.available_amount # preload anything required to get the amount, otherwise it's loaded during the assignation and there are undesirable consequences
      @project.attributes = params.require(:project).permit(tips_attributes: [:id, :amount_percentage])
      if @project.save
        message = "The tip amounts have been defined"
        if @project.has_undecided_tips?
          redirect_to decide_tip_amounts_project_path(@project), notice: message
        else
          redirect_to @project, notice: message
        end
      end
    end
  end

  def create
    project_name = params[:full_name].
      gsub(/https?\:\/\/github.com\//, '').
      gsub(/\#.+$/, '').
      gsub(' ', '')
    client = Octokit::Client.new \
      :client_id     => CONFIG['github']['key'],
      :client_secret => CONFIG['github']['secret']
    begin
      repo = client.repo project_name
      @project = Project.find_or_create_by host: "github", full_name: repo.full_name
      @project.update_repository_info repo
      redirect_to @project
    rescue Octokit::NotFound
      redirect_to projects_path, alert: "Project not found"
    end
  end

  private

  def load_project
    super(params[:id])
  end

  def project_params
    params.require(:project).permit(:hold_tips, tipping_policies_text_attributes: [:text])
  end
end
