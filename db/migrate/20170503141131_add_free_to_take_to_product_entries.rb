class AddFreeToTakeToProductEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :product_entries, :free_to_take, :boolean, default: false, null: false
  end
end
