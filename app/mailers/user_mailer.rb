class UserMailer < ApplicationMailer
  def email_user(user, password)
    @user = user
    @password = password
    mail(to: @user.login, subject: "Homelegance Kiosk Information")
  end
end
