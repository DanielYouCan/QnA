require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: exception.subject.id, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
      format.js  { render json: exception.subject.id, status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: error.body }
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
