class TipsController < ApplicationController
  before_action { load_project params }
  before_action { load_user    params }

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
    @tips = @tips.order(created_at: :desc).
                  page(params[:page]).
                  per(params[:per_page] || 30)
    respond_to do |format|
      format.html
      format.csv  { render csv: @tips, except: [:updated_at, :commit, :commit_message, :refunded_at, :decided_at], add_methods: [:user_name, :project_name, :decided?, :claimed?, :paid?, :refunded?, :txid] }
    end
  end
end
