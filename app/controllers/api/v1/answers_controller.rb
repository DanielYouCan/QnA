class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: false
  before_action :find_answer, only: :show
  before_action :find_question, only: %i[index create]

  def index
    respond_with(@question.answers)
  end

  def show
    respond_with @answer, serializer: SeparateAnswerSerializer
  end

  def create
    respond_with(answer = @question.answers.create(answer_params.merge(user: current_resource_owner)))
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
