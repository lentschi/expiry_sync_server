class AddDeletedAtToProductEntries < ActiveRecord::Migration
  def change
    add_column :product_entries, :deleted_at, :datetime
  end
end
