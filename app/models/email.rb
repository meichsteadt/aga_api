class Email < ApplicationRecord
  belongs_to :user
  validates :email_address, :product_id, presence: true
end
