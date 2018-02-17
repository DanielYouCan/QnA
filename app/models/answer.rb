class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: true, length: { minimum: 5 }

  default_scope { order(best: :desc, created_at: :asc) }
  scope :best, -> { where(best: true) }

  accepts_nested_attributes_for :attachments

  def set_best!
    Answer.transaction do
      question.best_answer.update!(best: false) if question.has_best_answer?
      self.update!(best: true)
    end
  end
end
