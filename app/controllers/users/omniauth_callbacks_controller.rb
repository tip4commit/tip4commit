# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :load_omniauth_info,
                  :load_user_from_omniauth_info,
                  :update_user_from_omniauth_info, only: :github

    def github
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
    end

    private

    def update_user_from_omniauth_info
      update_hash = @omniauth_info.slice(:name, :image).as_json
      update_hash[:email] = @omniauth_info.email if @omniauth_info.email.present?

      @user.update(update_hash)
    end

    def load_user_from_omniauth_info
      @user = User.find_by(nickname: @omniauth_info.nickname) ||
              User.find_by(email: @omniauth_info.email)
      return if @user

      @user = User.create_with_omniauth!(@omniauth_info) if @omniauth_info.email.present?
      return if @user

      set_flash_message(:error, :failure, kind: 'GitHub', reason: I18n.t('devise.errors.primary_email'))
      redirect_to new_user_session_path
    end

    def load_omniauth_info
      @omniauth_info = request.env['omniauth.auth']['info']
      return if @omniauth_info

      set_flash_message(:error, :failure, kind: 'GitHub', reason: I18n.t('devise.errors.omniauth_info'))
      redirect_to new_user_session_path
    end
  end
end
