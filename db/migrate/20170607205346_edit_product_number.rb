class EditProductNumber < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.string :number
    end
  end
end
