class Product < ApplicationRecord
  has_many :product_items
  has_and_belongs_to_many :sub_categories, unique: true
  has_and_belongs_to_many :warehouses, unique: true
  has_and_belongs_to_many :users

  def get_related_products
    if self.number[/([0-9]+)/]
      related_products = Product.where("number LIKE ?", self.number[/([0-9]+)/] + "%").sort_by {|product| product.popularity}.reverse
      self.update(related_products: related_products)
    end
  end

  def set_thumbnail
    self.update(thumbnail: self.images[0].gsub("homelegance", "homelegance-resized"))
  end

  def scramble_numbers
    number = self.number.split("-")
    if number[0].downcase.scan(/[a-z]/).length > 0
      new_number = "1" + number[0][0 .. number[0].downcase.scan(/[0-9]/).count - 1] + "2" + number[0][number[0].downcase.scan(/[0-9]/).count .. -1]
    else
      new_number = "1" + number[0] + "2"
    end
    if number.length > 1
      new_number += "-" + number[1]
    end
    new_number
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
