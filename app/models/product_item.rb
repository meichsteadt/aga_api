require 'csv'
class ProductItem < ApplicationRecord
  belongs_to :product

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
end
