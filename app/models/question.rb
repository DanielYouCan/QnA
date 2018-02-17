class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :body, :title, presence: true, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments

  def has_best_answer?
    answers.best.exists?
  end

  def best_answer
    answers.best.first
  end
end
