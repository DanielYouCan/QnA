class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[new create]

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@question), notice: 'Answer was succefully added'
    else
      flash.now[:warning] = 'Invalid attributes for answer'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
