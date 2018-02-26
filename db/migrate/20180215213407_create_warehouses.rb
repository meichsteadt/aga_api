class CreateWarehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouses do |t|
      t.string :name
    end

    drop_table :prices

    create_table :prices do |t|
      t.integer :warehouse_id
      t.integer :product_item_id
      t.float :amount

      t.timestamps
    end

    add_column :users, :warehouse_id, :integer
  end
end
