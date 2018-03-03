class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    provider("Facebook")
  end

  def twitter
    provider("Twitter")
  end

  private

  def provider(kind)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    
    if @user.persisted? && @user.authorizations.by_provider(auth.provider, auth.uid).first.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    elsif @user.persisted? && !@user.authorizations.by_provider(auth.provider, auth.uid).first.confirmed?
      redirect_to new_user_session_path, notice: "Confirm your email for signing in with #{kind}"
    else
      session["devise.twitter_data"] = request.env['omniauth.auth'].except("extra")
      redirect_to users_set_email_path
    end
  end
end
