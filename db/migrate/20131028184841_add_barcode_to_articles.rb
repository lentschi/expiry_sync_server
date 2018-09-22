class AddBarcodeToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :barcode, :string, :after => :id 
  end
end
