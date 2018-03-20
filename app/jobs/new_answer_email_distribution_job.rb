class NewAnswerEmailDistributionJob < ApplicationJob
  queue_as :mailers

  def perform(question, answer)
    question.subscribers.find_each do |subscriber|
      AnswerMailer.distribution(subscriber, answer).try(:deliver_later)
    end
  end
end
