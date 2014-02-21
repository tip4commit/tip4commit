require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "new_tip" do
    tip = build(:tip)

    mail = UserMailer.new_tip tip.user, tip
    assert_equal "You received a tip for your commit", mail.subject
    assert_equal [tip.user.email], mail.to
    assert_match "Hello", mail.body.encoded
  end

end
