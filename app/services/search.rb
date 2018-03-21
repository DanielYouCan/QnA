class Search
  SEARCH_OPTIONS = %w[All Questions Comments Answers Users]

  def self.search_handler(params)
    object = params[:search_object]
    value = params[:search_body]

    object == "All" ? ThinkingSphinx.search(value) : object.singularize.constantize.search(value)
  end
end
