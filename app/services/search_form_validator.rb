class SearchFormValidator
  include ActiveModel::Validations
  attr_accessor :search_body, :search_object

  validates :search_body, presence: true
  validates :search_object, inclusion: { in: Search::SEARCH_OPTIONS }

  def initialize(params)
    self.search_body = params[:search_body]
    self.search_object = params[:search_object]
  end
end
