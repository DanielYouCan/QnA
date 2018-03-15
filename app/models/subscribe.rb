class Subscribe < ApplicationRecord
  belongs_to :user
  belongs_to :question

  scope :by_question, -> (question) { where(question: question) }
  
  def self.find_subscribers(question)
    return false if question.subscribes.empty?
    ids = question.subscribes.pluck(:user_id)
    User.find(ids)
  end
end
