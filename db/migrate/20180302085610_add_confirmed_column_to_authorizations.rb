class AddConfirmedColumnToAuthorizations < ActiveRecord::Migration[5.1]
  def up
    add_column :authorizations, :confirmed, :boolean, default: true
  end

  def down
    remove_column :authorizations, :confirmed
  end
end
