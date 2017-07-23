class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login
      t.string :password_digest
      t.float :bedroom_mult
      t.float :dining_mult
      t.float :seating_mult

      t.timestamps
    end
  end
end
