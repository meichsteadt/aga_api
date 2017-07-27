User.create(login: "login", password: "password", bedroom_mult: 2.0, dining_mult: 2.0, seating_mult: 2.0)
Price.get_prices
Product.get_products
Product.all.each {|prod| prod.get_related_products}
