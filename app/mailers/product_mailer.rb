class ProductMailer < ApplicationMailer
  def email_product(email_address, product_id)
    @email_address = email_address
    @product = Product.find(product_id)
    mail(to: @email_address, subject: 'Saved item from kiosk')
  end
end
