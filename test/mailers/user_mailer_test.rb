require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "new_tip" do
    mail = UserMailer.new_tip
    assert_equal "New tip", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
