require 'csv'
require 'net/ftp'

class ProductItem < ApplicationRecord
  has_many :prices
  has_many :warehouses, through: :prices
  belongs_to :product

  def get_inventory(json)
    qty = json[self.number]
    if json[self.number + "*"]
      qty = json[self.number + "*"]
    end
    unless qty
      if self.number.split('-').last == "1CK"
        return json[self.number.gsub('1CK', "1")]
      elsif self.number.split('-').last == "1EK"
        return json[self.number.gsub('1EK', "1")]
      end
    end
    qty
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

  def self.get_inventory
    ftp = Net::FTP.new(ENV['FTP_URL'])
    ftp.login(ENV['FTP_LOGIN'], ENV['FTP_PASSWORD'])

    file_name = ftp.ls[-1].split(" ").last
    ftp.get(file_name)
    file = JSON.parse(File.read(file_name))
    hash = {}
    file.each do |row|
      confirmed = []
      current_can_sell_qty = row["current_can_sell_qty"]
      row["confirmed"].split("|").each do |e|
        split = e.split(';')
        date_numbers = split[0].split("/")
        date = Date.new(date_numbers[2].to_i, date_numbers[0].to_i, date_numbers[1].to_i)
        confirmed << [date, split[1]]
        confirmed.sort_by! {|c| c[0]}
      end
      hash[row["model"]] = {current_can_sell_qty: current_can_sell_qty, confirmed: confirmed}
    end
    ProductItem.all.each do |pi|
      inventory = pi.get_inventory(hash)
      if inventory
        can_sell_qty = inventory[:current_can_sell_qty].to_i
        dates = inventory[:confirmed]
        if dates.length > 0
          confirmed = dates.first.first.to_date
        else
          confirmed = nil
        end
        pi.update(can_sell: can_sell_qty, confirmed: confirmed)
      end
    end
  end

  def get_price(user)
    warehouse_id = user.warehouse_id
    price = self.prices.find_by_warehouse_id(warehouse_id)
    if price
      return price.amount
    else
      return self.price
    end
  end

  def self.priced(warehouse_id)
    self.joins(:prices).where('prices.warehouse_id = ?', warehouse_id)
  end

  def self.unpriced(warehouse_id)
    self.all - self.priced(warehouse_id)
  end

  def self.delete_discontinued(arr)
    (ProductItem.pluck(:number) & arr).each do |number|
      @pi = ProductItem.where(number: number)
      @pi.destroy if @pi
    end
    Product.without_product_items.each {|e| e.destroy}
  end

  def self.get_prices_to_update(hash)
    @product_items = []
    hash.each do |k, v|
      @pi = ProductItem.where(number: k)
      if @pi
        @pi.each do |pi|
          @product_items << pi if pi.price != v.remove(",").to_f.ceil
        end
      end
    end
    @product_items
  end

  def self.update_prices(hash)
    hash.each do |k, v|
      @pi = ProductItem.find(k)
      if @pi
        @pi.update(price: v.remove(",").to_f.ceil)
      end
    end
  end

  def self.orphaned
    ProductItem.where("product_id NOT IN (?)", Product.pluck(:id))
  end

  def self.delete_orphans
    ProductItem.orphaned.destroy_all
  end

  def self.get_csv
    ProductItem.order(:number).includes(:product).pluck("number", "price", "description", "dimensions", "products.number")
  end
end
