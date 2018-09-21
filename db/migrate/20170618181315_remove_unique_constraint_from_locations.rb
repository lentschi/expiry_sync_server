class RemoveUniqueConstraintFromLocations < ActiveRecord::Migration[4.2]
  def change
    remove_index :locations, [:creator_id, :name]
  end
end
