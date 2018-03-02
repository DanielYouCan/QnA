class UsersController < ApplicationController

  skip_before_action :authenticate_user!

  def set_email
  end
  
  def create_user
    User.create_user_for_network!(users_params, session)
  end

  private

  def users_params
    params.permit(:email)
  end
end
