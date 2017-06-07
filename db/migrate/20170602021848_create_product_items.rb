class CreateProductItems < ActiveRecord::Migration[5.0]
  def change
    create_table :product_items do |t|
      t.integer :product_id
      t.string :number
      t.integer :price
      t.string :description
      t.string :dimensions

      t.timestamps
    end
  end
end
