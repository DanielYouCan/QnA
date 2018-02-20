module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[rating_up rating_down]
  end

  def rating_up
    respond_to do |format|
      if @votable.rating_up!(current_user)
        format.json { render json: @votable }
      else
        format.json { render json: "You have already voted!", status: :forbidden }
      end
    end
  end

  def rating_down
    respond_to do |format|
      if @votable.rating_down!(current_user)
        format.json { render json: @votable }
      else
        format.json { render json: "You can't vote", status: :forbidden }
      end
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
