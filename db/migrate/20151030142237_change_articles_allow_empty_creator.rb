class ChangeArticlesAllowEmptyCreator < ActiveRecord::Migration[4.2]
  def change
    change_table :articles do |t|
      t.change :creator_id, :integer, :null => true
      t.change :modifier_id, :integer, :null => true
    end
    
    change_table :article_images do |t|
      t.change :creator_id, :integer, :null => true
      t.change :modifier_id, :integer, :null => true
    end
    
    change_table :producers do |t|
      t.change :creator_id, :integer, :null => true
      t.change :modifier_id, :integer, :null => true
    end
  end
end
