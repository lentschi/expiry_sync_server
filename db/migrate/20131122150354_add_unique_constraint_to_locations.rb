class AddUniqueConstraintToLocations < ActiveRecord::Migration
  def change
    add_index :locations, [:creator_id, :name], :unique => true
  end
end
