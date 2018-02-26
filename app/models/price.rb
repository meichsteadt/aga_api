class Price < ApplicationRecord
  belongs_to :product_item
  belongs_to :warehouse
end
