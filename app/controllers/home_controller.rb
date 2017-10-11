class HomeController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  def index
    @products = Product.where(category: "home")

    render json: @products
  end

  # GET /products/1
  def show
    pagenumber = params[:id].to_i
    min = (pagenumber - 1) * 6
    max = min + 6
    @products = Product.where(category: "home")[min...max]
    render json: @products
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find_by_number(params[:id])
    end
end
