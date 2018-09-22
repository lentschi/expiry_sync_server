class ChangeArticlesAllowEmptyBarcode < ActiveRecord::Migration[4.2]
  def change
    change_table :articles do |t|
      t.change :barcode, :string, :null => true
    end
  end
end
