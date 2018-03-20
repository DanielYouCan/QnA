class CreateSubscribes < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribes do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
    end

    remove_index :subscribes, :user_id
    remove_index :subscribes, :question_id
    add_index :subscribes, [:question_id, :user_id]
  end
end
