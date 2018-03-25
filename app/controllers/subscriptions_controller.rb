class SubscriptionsController < ApplicationController
  before_action :find_question, only: :create
  before_action :set_subscription, only: :destroy

  authorize_resource only: :destroy

  def create
    authorize! :subscribe, @question
    @question.subscriptions.create(user: current_user)
    redirect_to @question, notice: "You have subscribed to the question"
  end

  def destroy
    question = @subscription.question

    @subscription.destroy
    redirect_to question, notice: "You have unsubscribed from the question"
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
