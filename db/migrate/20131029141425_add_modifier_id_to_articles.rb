class AddModifierIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :modifier_id, :integer, :after => :creator_id
  end
end
