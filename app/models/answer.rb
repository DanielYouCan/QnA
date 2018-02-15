class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }
  default_scope { order(best: :desc, created_at: :asc) }
  scope :best, -> { where(best: true) }

  def best?
    best == true
  end

  def not_best?
    !best?
  end
end
