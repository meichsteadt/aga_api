class AddDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:users, :show_prices, true)
    change_column_default(:products, :popularity, 0)
  end
end
