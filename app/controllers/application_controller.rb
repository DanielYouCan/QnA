require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :gon_user, unless: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_resource_not_found

  private

  def rescue_with_resource_not_found
    render file: 'public/404.html'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
