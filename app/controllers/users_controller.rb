class UsersController < ApplicationController

  skip_before_action :authenticate_user!
  before_action :user_not_logged_in
  skip_authorization_check

  def set_email
  end

  def create_user
    if User.create_user_for_network!(users_params, session["devise.provider_data"])
      redirect_to new_user_session_path, notice: "We've sent you an email to confirm your account"
    else
      render :set_email
      flash.now[:alert] = "Invalid input for email"
    end
  end

  private

  def user_not_logged_in
    redirect_to root_path unless current_user.nil?
  end

  def users_params
    params.permit(:email)
  end
end
