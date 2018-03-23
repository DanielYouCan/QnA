class EmailFormValidator
  include ActiveModel::Validations
  attr_accessor :email

  validates :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def initialize(params)
    self.email = params[:email]
  end
end
