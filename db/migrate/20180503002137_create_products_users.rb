class CreateProductsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :products_users do |t|
      t.references :users, index: true
      t.references :products, index: true
    end
  end
end
