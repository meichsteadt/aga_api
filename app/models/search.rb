class Search
  def self.search(search, user_id)
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
    @products
  end
end
