class Question < ApplicationRecord
  validates :body,:title, presence: true
  
end
