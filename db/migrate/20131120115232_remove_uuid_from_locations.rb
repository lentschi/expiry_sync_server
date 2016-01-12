class RemoveUuidFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :uuid, :string
  end
end
