class AddModifierIdToProductEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :product_entries, :modifier_id, :integer, :after => :creator_id
  end
end
