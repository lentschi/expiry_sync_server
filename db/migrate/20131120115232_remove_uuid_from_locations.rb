class RemoveUuidFromLocations < ActiveRecord::Migration[4.2]
  def change
    remove_column :locations, :uuid, :string
  end
end
