class CommentsController < ApplicationController

  before_action :set_commentable, only: :create
  before_action :set_comment, only: %i[update destroy]
  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def update
    @comment.update(comment_params) if current_user.author_of?(@comment)
    @commentable = @comment.commentable
  end

  def destroy
    @comment.destroy if current_user.author_of?(@comment)
  end

  private

  def set_commentable
    @commentable =
      if params[:answer_id]
        Answer.find(params[:answer_id])
      elsif params[:question_id]
        Question.find(params[:question_id])
      end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
  end

end
