require 'csv'
class Price < ApplicationRecord
  def self.get_prices
    csv_text = File.read("item_with_price.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Price.create(number: row['number'], price: row['price'])
    end
  end
end
