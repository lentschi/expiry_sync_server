class AddSomeConstraintsAndIndices < ActiveRecord::Migration
  def change
    change_table :article_sources do |t|
      t.change :name, :string, :null => false
      t.change :created_at, :datetime, :null => false
      t.change :updated_at, :datetime, :null => false
    end
    add_index :article_sources, :name, :unique => true
    
    change_table :articles do |t|
      t.change :name, :string, :null => false
      t.change :article_source_id, :integer, :null => false
      t.change :barcode, :string, :null => false
      t.change :created_at, :datetime, :null => false
      t.change :updated_at, :datetime, :null => false
      t.change :creator_id, :integer, :null => false
      t.change :modifier_id, :integer, :null => false
    end
    add_index :articles, :article_source_id
    add_index :articles, :creator_id
    add_index :articles, :modifier_id
    add_index :articles, :created_at
    add_index :articles, :updated_at
    add_index :articles, :barcode
    add_index :articles, [:creator_id, :barcode], :unique => true
    
    change_table :locations do |t|
      t.change :uuid, :string, :null => false
      t.change :name, :string, :null => false
      t.change :created_at, :datetime, :null => false
      t.change :updated_at, :datetime, :null => false
      t.change :creator_id, :integer, :null => false
      t.change :modifier_id, :integer, :null => false
    end
    add_index :locations, :uuid
    add_index :locations, :creator_id
    add_index :locations, :modifier_id
    add_index :locations, :created_at
    add_index :locations, :updated_at
    
    change_table :product_entries do |t|
      t.change :article_id, :integer, :null => false
      t.change :location_id, :integer, :null => false
      t.change :amount, :integer, :null => false
      t.change :created_at, :datetime, :null => false
      t.change :updated_at, :datetime, :null => false
      t.change :creator_id, :integer, :null => false
      t.change :modifier_id, :integer, :null => false
    end
    add_index :product_entries, :article_id
    add_index :product_entries, :creator_id
    add_index :product_entries, :modifier_id
    add_index :product_entries, :created_at
    add_index :product_entries, :updated_at
    add_index :product_entries, :expiration_date
  end
end
