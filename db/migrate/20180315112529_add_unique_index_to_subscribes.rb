class AddUniqueIndexToSubscribes < ActiveRecord::Migration[5.1]
  def change
    remove_index :subscribes, [:question_id, :user_id]
    add_index :subscribes, [:question_id, :user_id], unique: true
  end
end
