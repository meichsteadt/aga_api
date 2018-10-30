class UpdatePricesController < ApplicationController
  before_action :authenticate_key
  def index
    hash = params[:prices_hash]
    @returned_arr = ProductItem.get_prices_to_update(hash)

    respond_to do |format|
      format.json { render json: @returned_arr}
    end
  end

  def update
    hash = JSON.parse(params[:prices_hash])
    ProductItem.update_prices(hash)

    respond_to do |format|
      format.json { render json: {message: "Completed", status: 200}}
    end
  end
end
