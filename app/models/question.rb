class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :body, :title, presence: true, length: { minimum: 5 }

  default_scope { order(updated_at: :desc) }

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].blank? }

  def has_best_answer?
    answers.best.exists?
  end

  def best_answer
    answers.best.first
  end
end
