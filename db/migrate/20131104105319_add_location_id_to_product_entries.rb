class AddLocationIdToProductEntries < ActiveRecord::Migration[4.2]
  def change
    add_reference :product_entries, :location, index: true
  end
end
