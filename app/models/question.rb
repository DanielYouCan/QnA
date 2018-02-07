class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :body, :title, presence: true, length: { minimum: 5 }
end
