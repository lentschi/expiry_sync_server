class AddModifierIdToProductEntries < ActiveRecord::Migration
  def change
    add_column :product_entries, :modifier_id, :integer, :after => :creator_id
  end
end
