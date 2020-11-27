# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, :load_user, :valid_user!, except: %i[login index]
  before_action :redirect_to_pretty_url,                       only:   [:show]

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

  def destroy
    if params[:user][:email] == @user.email
      sign_out(current_user)
      @user.destroy
      redirect_to root_url, notice: I18n.t('notices.account_deleted')
    else
      redirect_to @user, alert: I18n.t('errors.invalid_email')
    end
  end

  private

  def users_params
    params.require(:user).permit(:bitcoin_address, :password, :password_confirmation, :unsubscribed, :display_name, :denom)
  end

  def load_user
    super params
  end

  def valid_user!
    if current_user != @user
      flash[:error] = I18n.t('errors.access_denied')
      redirect_to root_path and return
    end
  end

  def redirect_to_pretty_url
    return unless request.get? && params[:id].present? && @user.nickname.present?

    respond_to do |format|
      case action_name
      when 'show'
        path = user_pretty_path @user.nickname
      end
      format.html { redirect_to path }
    end
  end
end
