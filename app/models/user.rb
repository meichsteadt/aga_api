class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  has_many :emails
  validates :login, uniqueness: true

  def invalidate_token
    self.update_columns(token: nil)
  end

  def self.valid_login?(login, password)
    user = find_by(login: login)
    if user && user.authenticate(password)
      user
    end
  end

  def multiplier(category)
    if category == "bedroom"
      return self.bedroom_mult
    elsif category == "dining"
      return self.dining_mult
    elsif category == "seating"
      return self.seating_mult
    elsif category == "youth"
      return self.youth_mult
    elsif category == "occasional"
      return self.occasional_mult
    elsif category == "home"
      return self.home_mult
    else
      return nil
    end
  end
end
