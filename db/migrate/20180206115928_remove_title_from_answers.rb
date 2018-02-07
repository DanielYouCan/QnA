class RemoveTitleFromAnswers < ActiveRecord::Migration[5.1]
  def change
    remove_column :answers, :title, :string
  end
end
