class ChangeSubscribesToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    remove_index :subscribes, [:question_id, :user_id]
    rename_table :subscribes, :subscriptions
    add_index :subscriptions, [:question_id, :user_id], unique: true
  end
end
