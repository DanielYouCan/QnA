module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating_up!(user)
    transaction do
      votes.create!(user: user, value: 1)
      self.rating += 1
      save!
    end
  end

  def rating_down!(user)
    transaction do
      votes.create!(user: user, value: -1)
      self.rating -= 1
      save!
    end
  end

  def cancel_vote!(user)
    vote = votes.where(user: user).first

    transaction do
      self.rating -= 1 if vote.value == 1
      self.rating += 1 if vote.value == -1
      save!
      vote.destroy!
    end
  end

end
