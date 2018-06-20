class AddShowSkuUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :show_sku, :boolean, default: false
  end
end
