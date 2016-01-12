class AddLocationIdToProductEntries < ActiveRecord::Migration
  def change
    add_reference :product_entries, :location, index: true
  end
end
