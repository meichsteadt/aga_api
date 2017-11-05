class AddThumbnailToProduct < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.string :thumbnail
    end
  end
end
