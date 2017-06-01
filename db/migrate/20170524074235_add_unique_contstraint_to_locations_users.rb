class AddUniqueContstraintToLocationsUsers < ActiveRecord::Migration
  def change
    add_index :locations_users, [ :user_id, :location_id ], :unique => true
  end
end
