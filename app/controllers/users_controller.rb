class UsersController < ApplicationController

  skip_before_action :authenticate_user!
  before_action :user_not_logged_in

  def set_email
  end

  def create_user
    if User.create_user_for_network!(users_params, session)
      redirect_to new_user_session_path, notice: "We've sent you an email to confirm your account"
    else
      render :set_email
      flash_options
    end
  end

  private

  def user_not_logged_in
    redirect_to root_path unless current_user.nil?
  end

  def flash_options
    flash_options =
      if users_params[:email].blank?
        "Email can't be blank"
      elsif users_params[:email] =~ /\A[^@\s]+@[^@\s]+\z/
        "Wrong input for email"
      end

    flash.now[:alert] = flash_options
  end

  def users_params
    params.permit(:email)
  end
end
