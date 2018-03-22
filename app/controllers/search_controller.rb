class SearchController < ApplicationController
  skip_before_action :authenticate_user!

  def search
    authorize! :do, :search
    if SearchFormValidator.new(search_params).valid?
      @results = Search.search_handler(search_params)
    else
      redirect_to root_path
    end
  end

  private

  def search_params
    params.permit(:search_body, :search_object)
  end
end
