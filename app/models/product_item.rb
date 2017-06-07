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
        prod.dining_prices(prod)
      end
    end
  end

  def bedroom_prices
    if self.number[-1] == "1" || self.number.last(2) == "HB"
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
    sum = 0
    if Price.where(number: (product_number + '-1')).first
      sum = sum + Price.where(number: (product_number + '-1')).first.price.to_f
    end
    if Price.where(number: (product_number + '-2')).first
      sum = sum + Price.where(number: (product_number + '-2')).first.price.to_f
    end
    if Price.where(number: (product_number + '-3')).first
      sum = sum + Price.where(number: (product_number + '-3')).first.price.to_f
    end
    sum
  end

  def king_bed_price(product_number)
    sum = 0
    if Price.where(number: (product_number + '-1')).first
      sum = sum + Price.where(number: (product_number + '-1')).first.price.to_f
    elsif Price.where(number: (product_number + '-1CK')).first
      sum = sum + Price.where(number: (product_number + '-1CK')).first.price.to_f
    elsif Price.where(number: (product_number + '-1EK')).first
      sum = sum + Price.where(number: (product_number + '-1EK')).first.price.to_f
    end
    if Price.where(number: (product_number + '-2')).first
      sum = sum + Price.where(number: (product_number + '-2')).first.price.to_f
    end
    if Price.where(number: (product_number + '-3CK')).first
      sum = sum + Price.where(number: (product_number + '-3CK')).first.price.to_f
    elsif Price.where(number: (product_number + '-3EK')).first
      sum = sum + Price.where(number: (product_number + '-3EK')).first.price.to_f
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

  def dining_prices(prod)
    if Price.where(number: prod.number).first
      prod.update(price: (Price.where(number: prod.number).first.price).to_f)
    end
  end
end
