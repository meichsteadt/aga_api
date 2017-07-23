class EditEmails < ActiveRecord::Migration[5.0]
  def change
    change_table :emails do |t|
      t.integer :user_id
      t.string :product_number
    end
  end
end
