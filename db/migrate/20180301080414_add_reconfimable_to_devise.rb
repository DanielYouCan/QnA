class AddReconfimableToDevise < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :unconfirmed_email, :string
  end

  def down
    remove_column :users, :unconfirmed_email
  end
end
