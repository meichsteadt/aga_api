class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  def index
    if params[:sub_category]
      if SubCategory.where("lower(name) LIKE ?", params[:sub_category])
        @products = SubCategory.where("lower(name) LIKE ?", params[:sub_category]).first.products
      end
    else
      @products = Product.all
    end
    if params[:user_id]
      sort_by = User.find(params[:user_id]).sort_by
      sort_by == "price"? @products = @products.order(avg_price: :desc) : @products = @products.order(popularity: :desc)
    end
    if params[:page_number]
      pagenumber = params[:page_number].to_i
      min = (pagenumber - 1) * 6
      max = min + 5
      render json: {"products": @products[min..max], "pages": @products.length}
    else
      render json: {"products": @products, "pages": @products.length}
    end
  end

  # GET /products/1
  def show
    if params[:user_id]
      show_user_products(params)
    else
      render json: {"product": @product, "product_items": @product.product_items}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
      @product.update(popularity: @product.popularity + 1)
    end

    def show_user_products(params)
      product_items = []
      @user = User.find(params[:user_id])
      @product = Product.find(params[:id])
      multiplier = @user.multiplier(@product.category)
      @product.product_items.each do |item|
        unless multiplier.nil?
          item.price = item.price * multiplier
        else
          item.price = nil
        end
        product_items.push(item)
      end
      render json: {"product": @product, "product_items": product_items.sort_by {|item| item.price}.reverse}
    end
end
