class AddBestColumnToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :best, :boolean
  end
end
