class AuthorizationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :find_authorization

  def set_confirmed
    if @authorization.set_confirmed!
      redirect_to root_path, notice: "You have confrimed your email! Now you can sign in using #{@authorization.provider.capitalize}"
    end
  end

  private

  def find_authorization
    @authorization = Authorization.find_by_confirmation_token(params[:confirmation_token])
  end

end
