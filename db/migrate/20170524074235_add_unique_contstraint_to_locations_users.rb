class AddUniqueContstraintToLocationsUsers < ActiveRecord::Migration[4.2]
  def change
    add_index :locations_users, [ :user_id, :location_id ], :unique => true
  end
end
