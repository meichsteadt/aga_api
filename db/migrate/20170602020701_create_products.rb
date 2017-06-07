class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :number
      t.string :name
      t.string :description
      t.string :image
      
      t.timestamps
    end
  end
end
