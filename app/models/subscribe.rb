class Subscribe < ApplicationRecord
  belongs_to :user
  belongs_to :question

  scope :by_question, -> (question) { where(question: question) }
end
