class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  validates :body, :title, presence: true, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments, reject_if: proc { |attr| attr['file'].blank? }

  def has_best_answer?
    answers.best.exists?
  end

  def best_answer
    answers.best.first
  end
end
