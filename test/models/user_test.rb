require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_full_name_when_name
    user = create(:user, name: 'test')
    assert_equal 'test', user.full_name
  end

  def test_full_name_when_nickname
    user = create(:user, nickname: 'nickname', name: nil)
    assert_equal 'nickname', user.full_name
  end

  def test_full_name_when_email
    user = create(:user, email: 'kd@vinsol.com', nickname: nil, name: nil)
    assert_equal 'kd@vinsol.com', user.full_name
  end
end
