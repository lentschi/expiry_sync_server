class CreateArticleImages < ActiveRecord::Migration[4.2]
  def change
    create_table :article_images do |t|
      t.string :source_url
      t.string :original_basename
      t.string :original_extname
      t.string :mime_type
      t.binary :image_data
      t.references :article, index: true, null: false
      t.integer :article_source_id, null: false
      t.integer :creator_id, null: false
      t.integer :modifier_id, null: false

      t.timestamps
    end
    add_index :article_images, :article_source_id
    add_index :article_images, :creator_id
    add_index :article_images, :modifier_id
  end
end
