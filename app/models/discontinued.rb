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

  def self.bye
    ds = CSV.open("ds.csv")
    ds.each do |row|
      if ProductItem.find_by_number(row[0])
        ProductItem.find_by_number(row[0]).destroy
      end
    end
    Product.all.each do |p|
      if p.product_items.length == 0
        p.destroy
      end
    end
  end
end
