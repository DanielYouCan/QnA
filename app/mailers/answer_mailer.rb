class AnswerMailer < ApplicationMailer
  def distribution(subscriber, answer)
    @subscriber = subscriber
    @answer = answer
    @question = answer.question
    @user = answer.user

    mail(to: subscriber.email, subject: "New answer")
  end
end
