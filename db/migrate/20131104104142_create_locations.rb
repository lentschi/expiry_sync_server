class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :uuid
      t.string :name
      t.integer :creator_id
      t.integer :modifier_id

      t.timestamps
    end
  end
end
