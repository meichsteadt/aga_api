class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  def index
    @products = Product.all

    render json: @products
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
    end

    def show_user_products(params)
      product_items = []
      @user = User.find(params[:user_id])
      @product = Product.find(params[:id])
      multiplier = @user.multiplier(@product.category)
      @product.product_items.each do |item|
        item.price = item.price * multiplier
        product_items.push(item)
      end
      render json: {"product": @product, "product_items": product_items}
    end
end
