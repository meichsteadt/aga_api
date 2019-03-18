class MissingItemsController < ApplicationController
  before_action :authenticate_key

  def index
    respond_to do |format|
      format.json {render json: missing_items}
    end
  end

  def update
    @product = Product.find_by_number(product_params[:number])
    product_item_params.each do |pi|
      unless @product.product_items.pluck(:number).include?(pi["number"])
        @product_item = @product.product_items.create(pi)
        @product_item.prices.create(warehouse_id: params[:warehouse_id], amount: pi[:price])
      end
    end
    render json: {"product": @product.as_json, "product_items": @product.product_items}
  end

private
  def missing_items
    mi_params[:product_arr] - ProductItem.pluck(:number)
  end

  def mi_params
    params.permit(:product_arr => [])
  end

  def product_params
    params.require(:product).permit(:number)
  end

  def product_item_params
    params.require(:product).permit(:product_items => [:number, :dimensions, :description, :price])["product_items"]
  end
end
