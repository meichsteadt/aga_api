class AddArrayToProductImages < ActiveRecord::Migration[5.0]
  def change
    remove_column :products, :image, :string
    change_table :products do |t|
      t.string :images, array: true, default: []
    end
  end
end
