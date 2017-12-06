class Email < ApplicationRecord
  belongs_to :user
  validates :email_address, :product_id, presence: true

  def self.seed
    emails = []
    Email.all.each do |email|
      new_email = JSON.parse(email.to_json)
      emails.push(new_email)
    end
    emails
  end
end
