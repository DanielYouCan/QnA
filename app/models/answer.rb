class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true, length: { minimum: 5 }

  default_scope { order(best: :desc, created_at: :asc) }
  scope :best, -> { where(best: true) }

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].blank? }

  def set_best!
    Answer.transaction do
      question.best_answer.update!(best: false) if question.has_best_answer?
      self.update!(best: true)
    end
  end
end
