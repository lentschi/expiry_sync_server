class AddCreatingToAcceptShareToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :creating_to_accept_share, :boolean, default: false, null: false
  end
end
