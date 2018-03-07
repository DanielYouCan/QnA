class CommentsController < ApplicationController

  before_action :find_commentable, only: :create
  before_action :set_comment, only: %i[update destroy]

  respond_to :js
  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def update
    @comment.update(comment_params)
    @commentable = @comment.commentable
    respond_with @comment
  end

  def destroy
    respond_with(@comment.destroy)
  end

  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = $1.classify.constantize.find(value)
      end
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
