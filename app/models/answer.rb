class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true, length: { minimum: 5 }

  after_create :publish_answer
  after_create :send_to_subscribers

  default_scope { order(best: :desc, created_at: :asc) }
  scope :best, -> { where(best: true) }

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].blank? }

  def set_best!
    Answer.transaction do
      question.best_answer.update!(best: false) if question.has_best_answer?
      self.update!(best: true)
    end
  end

  private

  def publish_answer
    ActionCable.server.broadcast(
      "question:#{question_id}:answers",
        { answer: self.to_json(include: %i[user attachments]) }
    )
  end

  def send_to_subscribers
    subscribers = Subscribe.find_subscribers(self.question)
    NewAnswerEmailDistributionJob.perform_now(subscribers, self) if subscribers
  end
end
