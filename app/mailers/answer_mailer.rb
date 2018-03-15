class AnswerMailer < ApplicationMailer
  def distribution(subsriber, answer)
    @subscriber = subsriber
    @answer = answer
    @question = answer.question
    @user = answer.user
  end
end
