class AddConfirmationTokenToAuthorizations < ActiveRecord::Migration[5.1]
  def change
    add_column :authorizations, :confirmation_token, :string
  end
end
