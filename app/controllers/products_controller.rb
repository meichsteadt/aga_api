class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update]

  # GET /products
  def index
    @products = Product.all

    render json: @products
  end

  # GET /products/1
  def show
    render json: {"product": @product, "product_items": @product.product_items}
  end

  def update
    @product.update(popularity: (@product.popularity + 1))
    render json: {"message": "product updated"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end
end
