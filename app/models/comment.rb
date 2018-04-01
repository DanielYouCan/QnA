class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true, touch: true

  validates :body, presence: true, length: { minimum: 5 }
  after_create :publish_comment

  default_scope { order(updated_at: :asc)}

  private

  def publish_comment
    question_id = commentable.is_a?(Question) ? commentable_id : commentable.question.id

    ActionCable.server.broadcast(
      "question:#{question_id}:comments",
        { comment: self.to_json(include: :user) } )
  end

end
