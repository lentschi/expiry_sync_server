class AddFreeToTakeToProductEntries < ActiveRecord::Migration
  def change
    add_column :product_entries, :free_to_take, :boolean, default: false, null: false
  end
end
