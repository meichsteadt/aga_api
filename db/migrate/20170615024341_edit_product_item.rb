class EditProductItem < ActiveRecord::Migration[5.0]
  def change
    change_table :product_items do |t|
      t.string :product_number
    end
  end
end
