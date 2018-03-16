class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy subscribe unsubscribe]
  before_action :gon_question_author, only: :show
  before_action :build_answer, only: :show
  before_action :current_ability, only: :show
  before_action :find_subscribe, only: :unsubscribe
  after_action :publish_question, only: :create

  respond_to :js, only: :update
  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  def subscribe
    @question.subscribes.create(user: current_user)
    redirect_to @question, notice: 'You have subscribed to the question'
  end

  def unsubscribe
    @subscribe.destroy
    redirect_to @question, notice: 'You have unsubscribed from the question'
  end

  private

  def gon_question_author
    gon.question_author_id = @question.user_id
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def find_subscribe
    @subscribe = @question.subscribes.where(user: current_user).first
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :destroy])
  end
end
