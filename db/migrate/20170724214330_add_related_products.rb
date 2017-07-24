class AddRelatedProducts < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.integer :related_products, array: true, default: []
    end
  end
end
