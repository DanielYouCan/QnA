class SubscribesController < ApplicationController
  before_action :find_question, only: :create
  before_action :set_subscribe, only: :destroy
  authorize_resource

  def create
    if @question.subscribes.create(user: current_user)
      redirect_to @question, notice: 'You have subscribed to the question'
    end
  end

  def destroy
    if @subscribe.destroy
      render template: 'questions/show'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_subscribe
    @subscribe = Subscribe.find(params[:id])
  end

  def current_ability
    @ability ||= Ability.new(current_user, question: @question)
  end
end
