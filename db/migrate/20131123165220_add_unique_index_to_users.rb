class AddUniqueIndexToUsers < ActiveRecord::Migration
  def change
    remove_index :users, :email # unique
    add_index :users, :email, unique: true
  end
end
