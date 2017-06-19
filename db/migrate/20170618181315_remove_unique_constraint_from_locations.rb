class RemoveUniqueConstraintFromLocations < ActiveRecord::Migration
  def change
    remove_index :locations, [:creator_id, :name]
  end
end
