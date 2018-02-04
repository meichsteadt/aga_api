require 'csv'
require 'net/ftp'

class ProductItem < ApplicationRecord

  def self.reset_prices
    ProductItem.all.each {|prod| prod.update(price: nil)}
  end

  def self.get_prices
    ProductItem.all.each do |prod|
      if Product.find(prod.product_id).category == "bedroom"
        prod.bedroom_prices
      elsif Product.find(prod.product_id).category == "dining"
        prod.dining_prices
      elsif Product.find(prod.product_id).category == "seating"
        prod.seating_prices
      else
        prod.youth_prices
      end
    end
    'got prices'
  end

  def bedroom_prices
    if self.number[-1] == "1" && self.number.last(2) != "11"
      product_number = self.number.split('-').first
      self.update(price: bed_price(product_number))
    elsif self.number[-1] == "K"
      product_number = self.number.split('-').first
      self.update(price: king_bed_price(product_number))
    elsif self.number.last(2) == "15"
      self.update(price: vanity_price(self.number))
    else
      if Price.where(number: self.number).first
        self.update(price: (Price.where(number: self.number).first.price).to_f)
      end
    end
  end

  def bed_price(product_number)
    sum = nil
    if self.number == "1402LP-1"
      sum = Price.where(number: "1402-1").first.price
      sum = sum + Price.where(number: "1402LP-2").first.price
      sum = sum + Price.where(number: "1402-3").first.price
    else
      if Price.where(number: (product_number + '-1')).first
        sum = Price.where(number: (product_number + '-1')).first.price.to_f
      end
      if Price.where(number: (product_number + '-2')).first
        sum = sum + Price.where(number: (product_number + '-2')).first.price.to_f
      end
      if Price.where(number: (product_number + '-3')).first
        sum = sum + Price.where(number: (product_number + '-3')).first.price.to_f
      end
    end
    sum
  end

  def king_bed_price(product_number)
    sum = nil
    if self.number == "1402LPK-1CK" || self.number == "1402LPK-1EK"
      sum = Price.where(number: "1402K-1CK").first.price
    elsif Price.where(number: (product_number + '-1')).first
      sum = Price.where(number: (product_number + '-1')).first.price.to_f
    elsif Price.where(number: (product_number + '-1CK')).first
      sum = Price.where(number: (product_number + '-1CK')).first.price.to_f
    elsif Price.where(number: (product_number + '-1EK')).first
      sum = Price.where(number: (product_number + '-1EK')).first.price.to_f
    end
    if Price.where(number: (product_number + '-2')).first
      sum = sum + Price.where(number: (product_number + '-2')).first.price.to_f
    elsif Price.where(number: (product_number + '-2EK')).first
      sum = sum + Price.where(number: (product_number + '-2EK')).first.price.to_f
    elsif Price.where(number: (product_number + '-2CK')).first
      sum = sum + Price.where(number: (product_number + '-2CK')).first.price.to_f
    end
    if Price.where(number: (product_number + '-3CK')).first
      sum = sum + Price.where(number: (product_number + '-3CK')).first.price.to_f
    elsif Price.where(number: (product_number + '-3EK')).first
      sum = sum + Price.where(number: (product_number + '-3EK')).first.price.to_f
    end
    if self.number == "1402LPK-1CK" || self.number == "1402LPK-1EK"
      sum = Price.where(number: "1402K-1CK").first.price
      sum = sum + Price.where(number: "1402LPK-2CK").first.price
      sum = sum + Price.where(number: "1402K-3CK").first.price
    end
    sum
  end

  def vanity_price(product_number)
    sum = 0
    if Price.where(number: (product_number + 'L')).first
      sum = sum + Price.where(number: (product_number + 'L')).first.price.to_f
    end
    if Price.where(number: (product_number + 'M')).first
      sum = sum + Price.where(number: (product_number + 'M')).first.price.to_f
    end
    if Price.where(number: (product_number + 'R')).first
      sum = sum + Price.where(number: (product_number + 'R')).first.price.to_f
    end
    sum
  end

  def dining_prices
    sum = nil
    if self.number == "5503"
      sum = Price.where(number: (self.number + "B")).first.price
      sum = sum + Price.where(number: (self.number + "M")).first.price
      sum = sum + Price.where(number: (self.number + "T")).first.price
    elsif self.number == "710-54" || self.number == "710-36RD" || self.number == "710-72"
      if self.number == "710-54" || self.number == "710-36RD"
        sum = Price.where(number: "G54RD").first.price
      else
        sum = Price.where(number: "G4272").first.price
      end
      sum = sum + Price.where(number: (self.number + "B")).first.price
      sum = sum + Price.where(number: (self.number + "C")).first.price
    elsif self.number == "710-72TR"
      sum = Price.where(number: self.number).first.price
      sum = sum + Price.where(number: "710-72TRC").first.price
      sum = sum + Price.where(number: "710-72TRG").first.price
    elsif Price.where(number: self.number).first
      sum = Price.where(number: self.number).first.price
      if Price.where(number: (self.number + "B")).first
        sum = sum + Price.where(number: (self.number + "B")).first.price
      end
      if self.number.last(2) == "50" && Price.where(number: (self.number.split('-').first+ "-55")).first
        sum = sum + Price.where(number: (self.number.split('-').first+ "-55")).first.price
      end
    end
    self.update(price: sum)
  end

  def seating_prices
    sum = nil
    if Price.where(number: self.number).first
      sum = Price.where(number: self.number).first.price
    elsif self.number.last(2) == "SC"
      prefix = self.number.split('-').first
      sum = Price.where(number: (prefix + "-TS")).first.price
      sum = sum + Price.where(number: (prefix + "-CA")).first.price
    elsif self.number.last(3) == "3PW" || self.number.last(3) == "2PW" || self.number.last(4) == "CNPW"
      sum = self.power_sofa_prices
    elsif self.number.first(4) == "8228"
      sum = Price.where(number: (self.number + "-L")).first.price
      sum = sum + Price.where(number: (self.number + "-R")).first.price
    elsif self.number.first(4) == "8211"
      sum = Price.where(number: (self.number + "-A")).first.price
      sum = sum + Price.where(number: (self.number + "-B")).first.price
    end
    self.update(price: sum)
  end

  def power_sofa_prices
    product = Product.find(self.product_id)
    prefix = self.number.split('-').first
    sum = nil
    if Price.where(number: (prefix + "-3LCPW")).first && self.number[-3] == "3"
      sum = Price.where(number: (prefix + "-3LCPW")).first.price
      sum = sum + Price.where(number: (prefix + "-3RCPW")).first.price
    elsif Price.where(number: (prefix + "-3LCPW")).first && self.number[-3] == "3"
      sum = Price.where(number: (prefix + "-3LCPW")).first.price
      sum = sum + Price.where(number: (prefix + "-3RCPW")).first.price
    elsif Price.where(number: (prefix + "-2LCPW")).first && self.number[-3] == "2"
      sum = Price.where(number: (prefix + "-2LCPW")).first.price
      sum = sum + Price.where(number: (prefix + "-2RCPW")).first.price
    elsif Price.where(number: (prefix + "-2LCPW")).first && self.number[-3] == "2"
      sum = Price.where(number: (prefix + "-2LCPW")).first.price
      sum = sum + Price.where(number: (prefix + "-2RCPW")).first.price
    elsif Price.where(number: (prefix + "-LRPW")).first
      sum = Price.where(number: (prefix + "-LRPW")).first.price
      sum = sum + Price.where(number: (prefix + "-RRPW")).first.price
    elsif Price.where(number: (prefix + "-LCPW")).first
      sum = Price.where(number: (prefix + "-LCPW")).first.price
      sum = sum + Price.where(number: (prefix + "-RCPW")).first.price
    end
    if self.number == "8318-3PW"
      sum = sum + Price.where(number: "8318-AC").first.price
    elsif self.number == "8318-2CNPW"
      sum = sum + Price.where(number: "8318-CN").first.price
    elsif Price.where(number: (prefix + "-3AC")).first && self.number.last(3) == "3PW"
      sum = sum + Price.where(number: (prefix + "-3AC")).first.price
    end
    sum
  end

  def youth_prices
    prefix = self.number.split("-").first
    price = Price.find_by_number(self.number)
    if self.number[-1] == "1" && price != nil
      price = Price.find_by_number(self.number).price
      if Price.find_by_number(prefix + "-3")
        price += Price.find_by_number(prefix + "-3").price
      end
    else
      price = Price.find_by_number(self.number)
      if price
        price = Price.find_by_number(self.number).price
      end
    end
    self.update(price: price)
  end

  def self.check_prices
    ProductItem.where(price: nil)
  end

  def self.write_prices
    odd_prices = []

    ProductItem.all.each do |item|
      if !Price.find_by_number(item.number)
        odd_prices.push(item)
      end
    end

    CSV.open( 'odd_prices.csv', 'w', :write_headers=> true,
    :headers => ["number", "price"] ) do |writer|
      odd_prices.each do |item|
        writer << [item.number, item.price]
      end
    end
  end

  def self.manual_prices
    csv_text = File.read("manual_prices.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      ProductItem.find_by_number(row["number"]).update(price: row['price'])
    end
  end

  def self.check_duplicates
    items = []
    returned = []
    ProductItem.all.sort_by {|item| item.number}.each {|item| items.push({number: item.number, product: Product.find(item.product_id)})}
    items.each do |item|
      if items.count(item) > 1
        returned.push(item[:product].id)
      end
    end
    returned
  end

  def get_inventory(json)
    qty = json[self.number]
    unless qty
      if self.number.split('-').last == "1CK"
        return json[self.number.gsub('1CK', "1")]
      elsif self.number.split('-').last == "1EK"
        return json[self.number.gsub('1EK', "1")]
      end
    end
    qty
  end

  def self.get_inventory
    ftp = Net::FTP.new(ENV['FTP_URL'])
    ftp.login(ENV['FTP_LOGIN'], ENV['FTP_PASSWORD'])

    file_name = ftp.ls[0].split(" ").last
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
end
