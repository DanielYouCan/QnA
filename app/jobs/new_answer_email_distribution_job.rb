class NewAnswerEmailDistributionJob < ApplicationJob
  queue_as :mailers

  def perform(subscribers, answer)
    subscribers.each do |subscriber|
      AnswerMailer.distribution(subscriber, answer).try(:deliver_later)
    end
  end
end
