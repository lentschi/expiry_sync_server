class CreateProducers < ActiveRecord::Migration
  def change
    create_table :producers do |t|
      t.string :name
      t.integer :creator_id
      t.integer :modifier_id

      t.timestamps
    end
    add_index :producers, :name, :unique => true
    add_index :producers, :creator_id
    add_index :producers, :modifier_id
    
    change_table :articles do |t|
      t.references :producer
      t.index :producer_id
    end
  end
end
