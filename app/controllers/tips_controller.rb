class TipsController < ApplicationController

  before_action :load_project

  def index
    if params[:project_id]
      @tips = @project.tips.includes(:user)
    elsif params[:user_id] && @user = User.find(params[:user_id])
      @tips = @user.tips.includes(:project)
    else
      @tips = Tip.includes(:user, :project)
    end
    @tips = @tips.order(created_at: :desc).
                  page(params[:page]).
                  per(params[:per_page] || 30)
    respond_to do |format|
      format.html
      format.csv  { render csv: @tips, except: [:updated_at, :commit, :commit_message, :refunded_at, :decided_at], add_methods: [:user_name, :project_name, :decided?, :claimed?, :paid?, :refunded?, :txid] }
    end
  end

  private

  def load_project
    super(params[:project_id]) if params[:project_id].present?
  end
end
