class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }
  default_scope { order(best: :desc, created_at: :asc) }
  scope :best, -> { where(best: true) }

  def is_best?
    best == true
  end

  def is_not_best?
    !is_best?
  end
end
