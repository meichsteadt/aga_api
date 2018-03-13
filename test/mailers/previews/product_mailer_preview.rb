class ProductMailerPreview < ActionMailer::Preview
  def email_product
    ProductMailer.email_product("test@test.com", 3681)
  end
end
