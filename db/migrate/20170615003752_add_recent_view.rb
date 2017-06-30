class AddRecentView < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.integer :popularity
    end
  end
end
