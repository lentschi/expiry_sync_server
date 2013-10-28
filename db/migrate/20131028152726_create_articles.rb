class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :name
      t.references :article_source
      t.integer :creator_id

      t.timestamps
    end
  end
end
