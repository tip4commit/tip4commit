class UsersController < ApplicationController

  before_action :authenticate_user!, :load_user, :valid_user!, except: [:login, :index]

  def show
    @user_tips   = @user.tips
    @recent_tips = @user_tips.includes(:project).order(created_at: :desc).first(5)
  end

  def index
    @users = User.order(withdrawn_amount: :desc, commits_count: :desc).where('commits_count > 0 AND withdrawn_amount > 0').page(params[:page]).per(30)
  end

  def update
    if @user.update_attributes(users_params)
      redirect_to @user, notice: I18n.t('notices.user_updated')
    else
      show
      render :show, alert: I18n.t('errors.wrong_bitcoin_address')
    end
  end

  def login
    @user = User.find_by(login_token: params[:token])
    if @user
      @user.confirm!
      sign_in_and_redirect @user, event: :authentication
      if params[:unsubscribe]
        @user.update unsubscribed: true
        flash[:alert] = I18n.t('notices.user_unsubscribed')
      end
    else
      redirect_to root_url, alert: I18n.t('errors.user_not_found')
    end
  end

  private
    def users_params
      params.require(:user).permit(:bitcoin_address, :password, :password_confirmation, :unsubscribed, :display_name)
    end

    def load_user
      @user = User.where(id: params[:id]).first
      unless @user
        flash[:error] = I18n.t('errors.user_not_found')
        redirect_to root_path and return
      end
    end

    def valid_user!
      if current_user != @user
        flash[:error] = I18n.t('errors.access_denied')
        redirect_to root_path and return
      end
    end
end
