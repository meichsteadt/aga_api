require 'csv'
class Product < ApplicationRecord
  has_many :product_items

  def self.reset
    Product.all.each do |prod|
      prod.destroy
    end
    ProductItem.all.each do |prod|
      prod.destroy
    end
  end

  def self.get_products
    Product.get_bedrooms
    Product.get_dining
  end

  def self.get_bedrooms
    csv_text = File.read("bedroom.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      product = Product.create(name: row['name'], description: row['description'], image: row['image'], number: row['number'], category: 'bedroom')
    end
    Product.get_bedroom_items
  end

  def self.get_bedroom_items
    csv_text = File.read("bedroom_items.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Product.find_by_number(row['product_number']).product_items.create(number: row['number'], description: row['description'], dimensions: row['dimensions'])
    end
  end

  def self.get_dining
    csv_text = File.read("dining.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Product.create(name: row['name'], description: row['description'], image: row['image'], number: row['number'], category: 'dining')
    end
    Product.get_dining_items
  end

  def self.get_dining_items
    csv_text = File.read("dining_items.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Product.find_by_number(row['product_number']).product_items.create(number: row['number'], description: row['description'], dimensions: row['dimensions'])
    end
  end

  def self.update_files
    `python bedroom_scraper.py`
    `python bedroom_items_scraper.py`
    `python dining_items_scraper.py`
    `python dining_scraper.py`
  end
end
