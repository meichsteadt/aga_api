class CreatePrices < ActiveRecord::Migration[5.0]
  def change
    create_table :prices do |t|
      t.string :number
      t.float :price
    end
  end
end
