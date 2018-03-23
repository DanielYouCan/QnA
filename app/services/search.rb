class Search
  include ActiveModel::Validations
  attr_accessor :search_body, :search_object

  SEARCH_OPTIONS = %w[All Questions Comments Answers Users]

  validates :search_body, presence: true
  validates :search_object, inclusion: { in: SEARCH_OPTIONS }

  def initialize(params)
    self.search_body = params[:search_body]
    self.search_object = params[:search_object]
  end

  def search_handler
    search_object == "All" ? ThinkingSphinx.search(search_body) : search_object.singularize.constantize.search(search_body)
  end
end
