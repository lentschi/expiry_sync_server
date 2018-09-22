class AddDeletedAtToProductEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :product_entries, :deleted_at, :datetime
  end
end
