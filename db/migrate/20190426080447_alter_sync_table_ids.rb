class AlterSyncTableIds < ActiveRecord::Migration[5.2]
  change_table :locations do |t|
    t.change :id, :string, null: false, autoincrement: false, limit: 36
  end

  change_table :locations_users do |t|
    t.change :location_id, :string, null: false, limit: 36
  end

  change_table :product_entries do |t|
    t.change :id, :string, null: false, autoincrement: false, limit: 36
    t.change :location_id, :string, null: false, limit: 36
    t.change :article_id, :string, null: false, limit: 36
  end

  change_table :articles do |t|
    t.change :id, :string, null: false, autoincrement: false, limit: 36
  end

  change_table :article_images do |t|
    t.change :id, :string, null: false, autoincrement: false, limit: 36
    t.change :article_id, :string, null: false, limit: 36
  end
end
