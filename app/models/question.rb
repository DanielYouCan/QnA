class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :body, :title, presence: true, length: { minimum: 5 }

  def has_best_answer?
    answers.best.length == 1
  end
end
