class AddSortByUser < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :sort_by, default: "price"
    end
  end
end
