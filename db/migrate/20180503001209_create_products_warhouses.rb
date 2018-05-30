class CreateProductsWarhouses < ActiveRecord::Migration[5.0]
  def change
    create_table :products_warehouses do |t|
      t.references :warehouse, index: true
      t.references :product, index: true
    end
  end
end
