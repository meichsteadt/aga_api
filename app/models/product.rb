require 'csv'

class Product < ApplicationRecord
  has_many :product_items
  has_and_belongs_to_many :sub_categories, unique: true

  def self.write
    @output = {}
    Product.all.each do |product|
      @output[product.number] = {product: product, product_items: product.product_items}
    end
    File.open('product_output.json', 'w') {|file| file.write(@output.to_json)}
  end

  def get_related_products
    if self.number[/([0-9]+)/]
      related_products = Product.where("number LIKE ?", self.number[/([0-9]+)/] + "%").sort_by {|product| product.popularity}.reverse
      products_to_add = []
      related_products.each do |product|
        if product.id != self.id && product.image != "https://www.homelegance.com/wp-content/themes/h2/images/misc/shim.gif"
          products_to_add.push(product.id)
        end
      end
      self.update(related_products: products_to_add)
    end
  end

  def self.reset
    Product.all.each do |prod|
      prod.destroy
    end
    ProductItem.all.each do |prod|
      prod.destroy
    end
    Product.get_products
  end

  def self.get_products
    categories = ["dining", "bedroom", "seating", "youth", "occasional", "home"]
    categories.each do |category|
      csv_text = File.read("#{category}.csv")
      csv = CSV.parse(csv_text, :headers => true)
      csv.each do |row|
        Product.create(name: row['name'], description: row['description'], image: row['image'], number: row['number'], category: category, popularity: 0)
      end
      csv_text = File.read("#{category}_items.csv")
      csv = CSV.parse(csv_text, :headers => true)
      csv.each do |row|
        Product.where(number: row['product_number'], category: category).first.product_items.create(number: row['number'], description: row['description'], dimensions: row['dimensions'], product_number: row['product_number'])
      end
    end
    ProductItem.get_prices
    Product.filter
    Product.all.each {|prod| prod.get_related_products}
  end

  def self.filter
    ProductItem.all.each do |product|
      if Discontinued.find_by_number(product.number)
        product.destroy
      end
      if product.number.split('-').first.last(3) == "KRF"
        updated_number = product.number.sub!("KRF", "RFK")
        product.update(number: updated_number)
      end
      if product.number == "1704k-1EK"
        product.update(number: "1704K-1EK")
      end
    end
  end

  def set_thumbnail
    self.update(thumbnail: self.images[0].gsub("homelegance", "homelegance-resized"))
  end

  def self.get_avg_price
    Product.all.each do |product|
      sum = 0
      product_items = product.product_items
      product_items.each do |item|
        price = item.price
        if price == nil
          price = 0
        end
        sum += price
      end
      if sum > 0
        avg_price = sum/product_items.length
      else
        avg_price = 0
      end
      product.update(avg_price: avg_price)
    end
  end

  def get_avg_price
    self.update(avg_price: self.product_items.map {|e| e.price }.sum/self.product_items.count)
  end

  def self.update_files
    `python bedroom_scraper.py`
    `python bedroom_items_scraper.py`
    `python dining_scraper.py`
    `python dining_items_scraper.py`
    `python seating_scraper.py`
    `python seating_items_scraper.py`
    `python youth_scraper.py`
    `python youth_item_scraper.py`
  end

  def self.write_file
    products = []
    product_items = []
    Product.all.each do |product|
      info = []
      info << product.number
      info << product.name
      info << "Homelegance"
      info << product.description
      info << product.category
      info << product['thumbnail']
      products << info
    end
    CSV.open('products.csv', "w", write_headers: true, headers: ['number', 'name', 'brand', 'description', 'category', 'image']) do |csv|
      products.each do |info|
        csv << info
      end
    end
    # CSV.open('product_items.csv', "w", write_headers: true, headers: ['produt_group_number', 'number','description', 'price', 'dimensions']) do |csv|
    #   product_items.each do |pi|
    #     csv << pi
    #   end
    # end
  end
end
