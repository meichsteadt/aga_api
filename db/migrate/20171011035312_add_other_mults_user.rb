class AddOtherMultsUser < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.float :youth_mult
      t.float :occasional_mult
      t.float :home_mult
    end
  end
end
