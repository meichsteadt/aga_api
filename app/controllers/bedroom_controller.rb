class BedroomController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  def index
    @products = Product.where(category: "bedroom")

    render json: @products
  end

  # GET /products/1
  def show
    @product.update(recent_view: DateTime.now)
    render json: {"product": @product, "product_items": @product.product_items}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find_by_number(params[:id])
    end
end
