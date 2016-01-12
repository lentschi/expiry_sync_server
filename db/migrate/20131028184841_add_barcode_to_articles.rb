class AddBarcodeToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :barcode, :string, :after => :id 
  end
end
