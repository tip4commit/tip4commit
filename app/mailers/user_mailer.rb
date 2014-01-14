class UserMailer < ActionMailer::Base
  def new_tip user
    @user = user

    mail to: user.email, subject: "You received a tip for your commit"
  end
end
