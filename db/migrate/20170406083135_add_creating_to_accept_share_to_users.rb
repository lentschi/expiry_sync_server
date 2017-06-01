class AddCreatingToAcceptShareToUsers < ActiveRecord::Migration
  def change
    add_column :users, :creating_to_accept_share, :boolean, default: 0, null: false
  end
end
