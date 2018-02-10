class User < ApplicationRecord
  has_many :questions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def is_author?(question)
    self.id == question.user_id
  end
end
