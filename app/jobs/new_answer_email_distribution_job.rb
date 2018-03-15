class NewAnswerEmailDistributionJob < ApplicationJob
  queue_as :mailers

  def perform(subscribers, answer)
    return AnswerMailer.distribution(subscribers, answer).deliver_later if subscribers.is_a?(User)

    subscribers.each do |subsriber|
      AnswerMailer.distribution(subsriber, answer).deliver_later
    end
  end
end
