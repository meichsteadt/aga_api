class AddDefaultToMults < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :dining_mult, :float, default: 2.0
    change_column :users, :youth_mult, :float, default: 2.0
    change_column :users, :seating_mult, :float, default: 2.0
    change_column :users, :bedroom_mult, :float, default: 2.0
    change_column :users, :occasional_mult, :float, default: 2.0
    change_column :users, :home_mult, :float, default: 2.0
  end
end
