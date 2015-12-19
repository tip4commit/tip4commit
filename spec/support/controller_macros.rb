module ControllerMacros
  def login_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @current_user = create(:user)
      @current_user.confirm
      sign_in @current_user
    end
  end
end
