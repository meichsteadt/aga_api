class CreateSubCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_categories do |t|
      t.string :name

      t.timestamps
    end

    create_table :products_sub_categories do |t|
      t.integer :product_id
      t.integer :sub_category_id

      t.timestamps
    end
  end
end
