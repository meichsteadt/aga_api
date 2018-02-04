class AddInventoryToProductItem < ActiveRecord::Migration[5.0]
  def change
    change_table :product_items do |t|
      t.integer :can_sell
      t.date :confirmed
    end
  end
end
