class EditProductNumber < ActiveRecord::Migration[5.0]
  def up
    change_column :products, :number, :string
  end
  def down
    change_column :products, :number, :integer
  end
end
