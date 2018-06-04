class PricesController < ApplicationController
  # before_action :authenticate_key
  before_action :set_product_item

  def create
    @price = @product_item.prices.new(price_params)
    if @price.save
      render json: @price, status: :created
    else
      render json: @price.errors, status: :unprocessable_entity
    end
  end

private

  def set_product_item
    @product_item = ProductItem.find(params[:product_item_id])
  end

  def price_params
    params.permit(:amount, :warehouse_id, :product_item_id)
  end

end
