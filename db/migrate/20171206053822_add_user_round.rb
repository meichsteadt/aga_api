class AddUserRound < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.boolean :round, default: false
    end
  end
end
