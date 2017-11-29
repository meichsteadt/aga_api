class BedroomController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  def index
    @products = Product.where(category: "bedroom")
    render json: @products
  end

  # GET /products/1
  def show
    pagenumber = params[:id].to_i
    min = (pagenumber - 1) * 6
    max = min + 5
    @products = Product.where(category: "bedroom")
    if params[:user_id]
      sort_by = User.find(params[:user_id]).sort_by
      sort_by == "price"? @products = @products.order(avg_price: :desc) : @products = @products.order(popularity: :desc)
    end
    render json: @products[min..max]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find_by_number(params[:id])
    end
end
