class SubscribesController < ApplicationController
  before_action :find_question, only: :create
  before_action :set_subscribe, only: :destroy
  skip_authorization_check

  def create
    if !current_user.subscribed_to_question?(@question)
      @question.subscribes.create(user: current_user)
      redirect_to @question, notice: "You have subscribed to the question"
    end
  end

  def destroy
    question = @subscribe.question

    if current_user.subscribed_to_question?(question)
      @subscribe.destroy
      redirect_to question, notice: "You have unsubscribed from the question"
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_subscribe
    @subscribe = Subscribe.find(params[:id])
  end
end
