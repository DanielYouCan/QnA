class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :set_answer, only: :destroy

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question), notice: 'Answer was succefully added'
    else
      flash.now[:warning] = 'Invalid attributes for answer'
      render :create
    end
  end

  def destroy
    @question = @answer.question

    if current_user.is_author?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Your answer was successfully deleted.'
    else
      flash.now[:warning] = "You can't delete this answer."
      render 'questions/show'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
