class Email < ApplicationRecord
  validates :email_address, :product_id, presence: true
end
