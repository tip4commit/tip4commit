require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should redirect if not loggedd in" do
    create(:user)
    get :show, {:id => 1}
    assert_response :redirect
  end
end
