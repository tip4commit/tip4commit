class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # render text: "#{request.env["omniauth.auth"].to_json}"
    info = request.env["omniauth.auth"]["info"]
    @user = User.find_by :email => info["email"]
    unless @user
      generated_password = Devise.friendly_token.first(8)
      @user = User.create!(
        :email => info['email'],
        :password => generated_password,
        :nickname => info['nickname']
      )
    end

    @user.name = info['name']
    @user.image = info['image']
    @user.save
    
    sign_in_and_redirect @user, :event => :authentication
    set_flash_message(:notice, :success, :kind => "GitHub") if is_navigational_format?
  end
end
