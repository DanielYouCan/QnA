module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable
  end

  def rating_up!(user)
    return false unless votable?(user)

    self.transaction do
      self.votes.create!(user: user, value: 1)
      self.rating += 1
      self.save!
    end
  end

  def rating_down!(user)
    return false unless votable?(user)

    self.transaction do
      self.votes.create!(user: user, value: -1)
      self.rating -= 1
      self.save!
    end
  end

  def cancel_vote!(user)
    return false if votes.where(user: user).empty?
    vote = votes.where(user: user).first

    self.transaction do
      self.rating -= 1 if vote.value == 1
      self.rating += 1 if vote.value == -1
      self.save!
      vote.destroy!
    end
  end

  private

  def votable?(user)
    self.votes.where(user: user).blank? && !user.author_of?(self)
  end
end
