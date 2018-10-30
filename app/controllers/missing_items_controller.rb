class MissingItemsController < ApplicationController
  before_action :authenticate_key

  def index
    render json: missing_items
  end

private
  def missing_items
    mi_params[:product_arr] - ProductItem.pluck(:number)
  end

  def mi_params
    params.permit(:product_arr => [])
  end
end
