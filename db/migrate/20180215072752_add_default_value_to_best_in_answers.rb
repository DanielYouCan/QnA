class AddDefaultValueToBestInAnswers < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:answers, :best, :false)
  end
end
