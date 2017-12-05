class Search
  def self.search(search, user_id, page_number = nil)
    @products = Product.where("lower(name) LIKE ? OR lower(number) LIKE ? OR lower(description) LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%").to_a
    SubCategory.where("lower(name) LIKE ?", "%#{search}%").each do |cat|
      cat.products.each do |product|
        if !@products.include?(product)
          @products << product
        end
      end
    end
    if user_id
      @products.sort_by! {|prod| prod.avg_price}
    end
    if page_number
      pagenumber = page_number.to_i
      min = (pagenumber - 1) * 6
      max = min + 5
      {"products": @products[min..max], "pages": @products.length}
    else
      {"products": @products, "pages": @products.length}
    end
  end
end
