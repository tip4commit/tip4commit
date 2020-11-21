require 'net/http'

class ProjectsController < ApplicationController
  include ProjectsHelper

  before_action :load_project, only: [:show, :edit, :update, :decide_tip_amounts]
  before_action :redirect_to_pretty_url, only: [:show, :edit, :decide_tip_amounts]

  def index
    @projects = Project.order(projects_order).page(params[:page]).per(30)
  end

  def search
    if params[:query].present?
      if BLACKLIST.include?(params[:query])
        render :blacklisted and return
      elsif project = Project.find_by_url(params[:query])
        redirect_to pretty_project_path(project) and return
      end
    end

    @projects = Project.search(params[:query].to_s).order(projects_order).page(params[:page]).per(30)
    render :index
  end

  def show
    render :blacklisted and return if BLACKLIST.include? @project.github_url

    @project_tips = @project.tips.with_address
    @recent_tips  = @project_tips.with_address.order(created_at: :desc).first(5)
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
      percentages = params[:project][:tips_attributes].values.map { |tip| tip['amount_percentage'].to_f }
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

  def load_project ; super params ; end ;

  def project_params
    params.require(:project).permit(:branch, :disable_notifications, :hold_tips, tipping_policies_text_attributes: [:text])
  end

  def projects_order
    {
      'balance'     => { available_amount_cache: :desc, watchers_count: :desc, full_name: :asc },
      'watchers'    => { watchers_count: :desc, available_amount_cache: :desc, full_name: :asc },
      'repository'  => { full_name: :asc, available_amount_cache: :desc, watchers_count: :desc },
      'description' => { description: :asc, available_amount_cache: :desc, watchers_count: :desc, full_name: :asc }
    }.[](params[:order] || 'balance')
  end

  def redirect_to_pretty_url
    return unless request.get? && params[:id].present?

    begin
      respond_to do |format|
        case action_name
        when 'show'
          path = pretty_project_path                    @project
        when 'edit'
          path = pretty_project_edit_path               @project
        when 'decide_tip_amounts'
          path = pretty_project_decide_tip_amounts_path @project
        end
        format.html { redirect_to path }
      end
    rescue ActionController::UnknownFormat
    end
  end
end
