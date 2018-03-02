class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    provider("Facebook")
  end

  def twitter
    provider("Twitter")
  end

  private

  def provider(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted? && @user.authorizations.last.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      session["devise.twitter_data"] = request.env['omniauth.auth'].except("extra")
      redirect_to users_set_email_path
    end
  end
end
