class AddQuestionReferenceToAttachments < ActiveRecord::Migration[5.1]
  def change
    add_reference :attachments, :question, foreign_key: true
  end
end
