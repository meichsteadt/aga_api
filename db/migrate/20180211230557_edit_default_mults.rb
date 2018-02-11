class EditDefaultMults < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:users, :bedroom_mult, 2.2)
    change_column_default(:users, :dining_mult, 2.2)
    change_column_default(:users, :youth_mult, 2.2)
    change_column_default(:users, :seating_mult, 2.2)
    change_column_default(:users, :occasional_mult, 2.2)
    change_column_default(:users, :home_mult, 2.2)
  end
end
