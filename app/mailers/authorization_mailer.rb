class AuthorizationMailer < ApplicationMailer
  def email_confirmation(authorization)
    @user = authorization.user
    @authorization = authorization
    mail(to: @user.email, subject: "Email Confirmation")
  end
end
