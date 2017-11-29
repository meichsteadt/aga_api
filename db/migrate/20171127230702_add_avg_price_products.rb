class AddAvgPriceProducts < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.float :avg_price
    end
  end
end
