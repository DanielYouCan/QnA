class Api::V1::BaseController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session, only: :create
  before_action :doorkeeper_authorize!

  respond_to :json

  protected

  def current_resource_owner
    current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
