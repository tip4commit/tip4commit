# frozen_string_literal: true

class TipsController < ApplicationController
  before_action { load_project }
  before_action { load_user }

  def index
    if @project.present?
      @tips = @project.tips.includes(:user).with_address
    elsif @user.present?
      if @user.bitcoin_address.present?
        @tips = @user.tips.includes(:project)
      else
        flash[:error] = I18n.t('errors.user_not_found')
        redirect_to users_path and return
      end
    else
      @tips = Tip.with_address.includes(:project)
    end
    @tips = @tips.order(created_at: :desc)
                 .page(params[:page])
                 .per(params[:per_page] || 30)
    respond_to do |format|
      format.html
      format.csv do
        render csv: @tips, except: %i[updated_at commit commit_message refunded_at decided_at],
               add_methods: %i[user_name project_name decided? claimed? paid? refunded? txid]
      end
    end
  end

  private

  def load_project
    return unless pretty_project_path? || params[:project_id].present?

    if pretty_project_path?
      @project = Project.find_by_service_and_repo(params[:service], params[:repo])
    elsif params[:project_id].present?
      @project = Project.where(id: params[:project_id]).first
      redirect_to project_tips_pretty_path(@project.host, @project.full_name) if @project
    end

    project_not_found unless @project
  end

  def load_user
    return unless params[:user_id].present? || params[:nickname].present?

    if params[:nickname].present?
      @user = User.find_by_nickname(params[:nickname])
    elsif params[:user_id].present?
      @user = User.where(id: params[:user_id]).first
      redirect_to user_tips_pretty_path(@user.nickname) if @user
    end

    user_not_found unless @user
  end
end
