class UsersController < ApplicationController

  before_action except: [:login, :index] do
    @user = User.find params[:id]
    unless current_user && current_user == @user
      redirect_to root_path
    end
  end

  def show
  end

  def index
    @users = User.order(:withdrawn_amount => :desc, :commits_count => :desc).where('commits_count > 0').page(params[:page]).per(30)
  end

  def update
    if @user.update_attributes(users_params)
      redirect_to @user, notice: 'Your information saved!'
    else
      render :show, alert: 'Error updating bitcoin address'
    end
  end

  def login
    @user = User.find_by(login_token: params[:token])
    if @user
      sign_in_and_redirect @user, :event => :authentication
      if params[:unsubscribe]
        @user.update unsubscribed: true
        flash[:alert] = 'You unsubscribed! Sorry for bothering you. Although, you still can leave us your bitcoin address to get your tips.'
      end
    else
      redirect_to root_url, alert: 'User not found'
    end
  end

  private
    def users_params
      params.require(:user).permit(:bitcoin_address, :password, :password_confirmation)
    end
end
