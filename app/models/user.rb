class User < ApplicationRecord
  has_many :questions
  has_many :answers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def is_author?(item)
    id == item.user_id
  end
end
