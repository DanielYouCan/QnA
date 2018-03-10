class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource
  before_action :find_answer, only: :show
  before_action :find_question, only: :index

  def index
    respond_with(@question.answers)
  end

  def show
    respond_with @answer, serializer: SeparateAnswerSerializer
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
