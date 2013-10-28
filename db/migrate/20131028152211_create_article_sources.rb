class CreateArticleSources < ActiveRecord::Migration
  def change
    create_table :article_sources do |t|
      t.string :name

      t.timestamps
    end
  end
end
