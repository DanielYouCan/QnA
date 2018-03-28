class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def facebook
    provider("Facebook")
  end

  def twitter
    provider("Twitter")
  end

  def vkontakte
    provider("Vkontakte")
  end

  private

  def provider(kind)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user.persisted?
      if @user.has_confirmed_authorization?(auth.provider, auth.uid)
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
      else
        redirect_to new_user_session_path, notice: "Confirm your email for signing in with #{kind}"
      end
    else
      session["devise.provider_data"] = request.env['omniauth.auth'].except("extra")
      redirect_to users_set_email_path
    end
  end
end
