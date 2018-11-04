class PriceCsvController < ApplicationController
  before_action :authenticate_key
  def index
    render json: ProductItem.get_csv
  end
end
