class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource
  before_action :find_question, only: :show

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question, serializer: SeparateQuestionSerializer
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end
end
