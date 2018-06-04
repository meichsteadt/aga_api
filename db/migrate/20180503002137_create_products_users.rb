class CreateProductsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :products_users do |t|
      t.references :user, index: true
      t.references :product, index: true
    end
  end
end
