class TipsController < ApplicationController

  before_action :load_project

  def index
    if params[:project_id]
      @tips = @project.tips.includes(:user).order(created_at: :desc).page(params[:page]).per(30)
    elsif params[:user_id] && @user = User.find(params[:user_id])
      @tips = @user.tips.includes(:project).order(created_at: :desc).page(params[:page]).per(30)
    else
      @tips = Tip.includes(:user, :project).order(created_at: :desc).page(params[:page]).per(30)
    end
  end

  private

  def load_project
    super(params[:project_id]) if params[:project_id].present?
  end
end
