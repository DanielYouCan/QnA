module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[rating_up rating_down cancel_vote]
    load_and_authorize_resource only: %i[rating_up rating_down cancel_vote]
  end

  def rating_up
    respond_to do |format|
      @votable.rating_up!(current_user)
      format.json { render json: @votable, serializer: VotableSerializer }
    end
  end

  def rating_down
    respond_to do |format|
      @votable.rating_down!(current_user)
      format.json { render json: @votable, serializer: VotableSerializer }
    end
  end

  def cancel_vote
    respond_to do |format|
      @votable.cancel_vote!(current_user)
      format.json { render json: @votable, serializer: VotableSerializer }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

end
