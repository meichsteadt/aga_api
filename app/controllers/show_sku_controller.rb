class ShowSkuController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    render json: {show_sku: @user.show_sku, show_prices: @user.show_prices}
  end
end
