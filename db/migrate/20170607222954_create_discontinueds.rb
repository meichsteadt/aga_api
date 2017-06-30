class CreateDiscontinueds < ActiveRecord::Migration[5.0]
  def change
    create_table :discontinueds do |t|
      t.string :number
    end
  end
end
