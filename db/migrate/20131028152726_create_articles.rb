class CreateArticles < ActiveRecord::Migration[4.2]
  def change
    create_table :articles do |t|
      t.string :name
      t.references :article_source
      t.integer :creator_id

      t.timestamps
    end
  end
end
