class AddThumbnailSubCategory < ActiveRecord::Migration[5.0]
  def change
    change_table :sub_categories do |t|
      t.string :thumbnail
    end
  end
end
