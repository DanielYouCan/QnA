class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    User.find_each do |user|
      DailyMailer.digest(user).try(:deliver_later)
    end
  end
end
