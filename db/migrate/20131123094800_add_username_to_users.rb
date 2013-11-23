class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, after: :id, null: false, default: ''
    add_index :users, :username, unique: true
    remove_index :users, :email # unique
    add_index :users, :email
    
    change_table :users do |t|
      t.change :email, :string, null: true
    end
  end
end
