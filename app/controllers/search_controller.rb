class SearchController < ApplicationController
  skip_before_action :authenticate_user!

  def search
    authorize! :do, :search
    search = Search.new(search_params)

    if search.valid?
      @search_body = search_params[:search_body]
      @search_object = search_params[:search_object]
      @results = search.search_handler
    else
      redirect_to root_path
    end
  end

  private

  def search_params
    params.permit(:search_body, :search_object)
  end
end
