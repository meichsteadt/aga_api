class AddUserScrabmleNumbers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :scramble_numbers, :boolean, default: false
  end
end
