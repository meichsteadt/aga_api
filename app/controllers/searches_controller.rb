class SearchesController < ApplicationController
  before_action :search
  def index
    render json: @products
  end

private
  def search
    user_id = nil

    if params[:user_id]
      user_id = params[:user_id]
    end
    @products = Search.search(params[:search], user_id, params[:page_number])
  end
end
