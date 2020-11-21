class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def new_tip(user, tip)
    @user = user
    @tip  = tip

    mail to: user.email, subject: "You received a tip for your commit"
  end

  def check_bitcoin_address(user)
    @user = user

    mail to: user.email, subject: "Check your Bitcoin address"
  end
end
