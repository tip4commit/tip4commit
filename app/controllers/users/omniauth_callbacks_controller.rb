# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :load_omniauth_info, only: :github

    def github
      @user = User.find_by(nickname: @omniauth_info.nickname) ||
              User.find_by(email: @omniauth_info.email)

      if @user.present?
        if @omniauth_info.email.present? && @user.email != @omniauth_info.email
          # update email if it has been changed
          @user.update email: @omniauth_info.email
        end
      elsif @omniauth_info.email.present? # user not found
        @user = User.create_with_omniauth!(@omniauth_info)
      else
        set_flash_message(:error, :failure, kind: 'GitHub', reason: I18n.t('devise.errors.primary_email'))
        redirect_to new_user_session_path and return
      end

      @user.update(@omniauth_info.slice(:name, :image).as_json)

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
    end

    private

    def load_omniauth_info
      @omniauth_info = request.env['omniauth.auth']['info']
      unless @omniauth_info
        set_flash_message(:error, :failure, kind: 'GitHub', reason: I18n.t('devise.errors.omniauth_info'))
        redirect_to new_user_session_path and return
      end
    end
  end
end
