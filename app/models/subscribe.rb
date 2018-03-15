class Subscribe < ApplicationRecord
  belongs_to :user
  belongs_to :question

  def self.find_subscribers(question)
    return false if question.subscribes.empty?
    ids = question.subscribes.pluck(:user_id)
    User.find(ids)
  end
end
