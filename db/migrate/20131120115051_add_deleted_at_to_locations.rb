class AddDeletedAtToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :deleted_at, :datetime
  end
end
