class UserMailer < ApplicationMailer
  def email_user(email, password)
    @email = email
    @password = password
    mail(to: @email, subject: "Homelegance Kiosk Information")
  end
end
