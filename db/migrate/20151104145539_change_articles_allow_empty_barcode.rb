class ChangeArticlesAllowEmptyBarcode < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.change :barcode, :string, :null => true
    end
  end
end
