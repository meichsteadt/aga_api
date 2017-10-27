require "csv"
class Discontinued < ApplicationRecord
  def self.get_discontinued
    csv_text = File.read("discontinued.csv")
    csv = CSV.parse(csv_text)
    csv.each do |row|
      Discontinued.create(number: row)
    end
  end

  def self.get_tbds(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text)
    csv.each do |row|
      product = Product.find_by_number(row)
      if product
        product.destroy
      end
    end
  end
end
orphan = []
ProductItem.all.each do |item|
  product = Product.where(id: item.product_id)
  if product == []
    orphan.push(item.number)
  end
end
orphan
