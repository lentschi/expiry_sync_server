class AddModifierIdToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :modifier_id, :integer, :after => :creator_id
  end
end
