class AnswersController < ApplicationController
  include Voted

  before_action :find_question, only: :create
  before_action :set_answer, only: %i[destroy update set_best]

  respond_to :js
  authorize_resource
  skip_authorization_check only: :create

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_best
    @question = @answer.question
    @answer.set_best!
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
