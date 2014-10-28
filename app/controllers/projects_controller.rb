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
    redirect_to_pretty_url if params[:id].present?

    @project.update_bitcoin_address if @project.bitcoin_address.nil?

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
    begin
      respond_to do |format|
        format.html { redirect_to pretty_project_path(@project) }
      end
    rescue ActionController::UnknownFormat
    end
  end
end
