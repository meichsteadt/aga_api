class UserMailerPreview < ActionMailer::Preview
  def email_user
    UserMailer.email_user(User.new(login: "email", id: 123), "password")
  end
end
