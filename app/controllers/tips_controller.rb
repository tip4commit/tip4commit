class TipsController < ApplicationController

  before_action :load_project

  def index
    if params[:project_id]
      @tips = @project.tips.includes(:user).with_address
    elsif params[:user_id] && @user = User.find(params[:user_id])
      if @user.nil? || @user.bitcoin_address.blank?
        flash[:error] = I18n.t('errors.user_not_found')
        redirect_to users_path and return
      end

      @tips = @user.tips.includes(:project)
    else
      @tips = Tip.with_address.includes(:project)
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
