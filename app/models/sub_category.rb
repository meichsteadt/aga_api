class SubCategory < ApplicationRecord
  has_and_belongs_to_many :products


  def self.write_file
    subs = {}
    SubCategory.all.each do |sub_category|
      subs["#{sub_category.name}"] = sub_category.products.map { |e| e.thumbnail }
    end

    File.open('subs.json', 'w') {|file| file.write(subs.to_json)}
  end
end
