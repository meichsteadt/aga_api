class Warehouse < ApplicationRecord
  has_many :users
  has_many :prices
  has_many :products
  has_many :product_items, through: :prices
end
