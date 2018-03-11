class SeparateAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :question_id
  has_many :comments
  has_many :attachments, serializer: AttachmentSerializer
end
