class CreateProductEntries < ActiveRecord::Migration
  def change
    create_table :product_entries do |t|
      t.string :description
      t.integer :amount
      t.date :expiration_date
      t.references :article
      t.integer :creator_id

      t.timestamps
    end
  end
end
