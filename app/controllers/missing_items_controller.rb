class MissingItemsController < ApplicationController
  before_action :authenticate_key

  def index
    respond_to do |format|
      format.json {render json: missing_items}
    end
  end

private
  def missing_items
    mi_params[:product_arr] - ProductItem.pluck(:number)
  end

  def mi_params
    params.permit(:product_arr => [])
  end
end
