class CreateAlternateServers < ActiveRecord::Migration
  def up
    create_table :alternate_servers do |t|
      t.string :url, unique: true
      t.integer :creator_id, index: true, null: false
      t.integer :modifier_id, index: true, null: false
      t.timestamp :deleted_at, index: true

      t.timestamps
    end
    
    AlternateServer.create_translation_table!({
      name: {type: :string, null: false, default: ''},
      description: {type: :text, null: true} 
    })
  end
  
  def down
    drop_table :alternate_servers
    AlternateServer.drop_translation_table!
  end
end
