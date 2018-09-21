class AddUniqueConstraintToLocations < ActiveRecord::Migration[4.2]
  def change
    add_index :locations, [:creator_id, :name], :unique => true
  end
end
