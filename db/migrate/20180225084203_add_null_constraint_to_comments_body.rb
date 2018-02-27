class AddNullConstraintToCommentsBody < ActiveRecord::Migration[5.1]
  def change
    change_column_null :comments, :body, false
  end
end
