class User < ApplicationRecord
  has_secure_password
  has_many :emails
  validates :login, uniqueness: true
end
