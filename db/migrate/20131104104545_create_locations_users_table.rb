class CreateLocationsUsersTable < ActiveRecord::Migration
  def change
    create_table :locations_users, id: false do |t|
      t.references :location
      t.references :user
    end
    add_index :locations_users, [:location_id, :user_id]
    add_index :locations_users, :user_id
  end
end
