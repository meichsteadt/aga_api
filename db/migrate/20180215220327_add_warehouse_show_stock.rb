class AddWarehouseShowStock < ActiveRecord::Migration[5.0]
  def change
    add_column :warehouses, :show_stock, :boolean, default: false
    add_column :users, :show_prices, :boolean, defualt: true
  end
end
