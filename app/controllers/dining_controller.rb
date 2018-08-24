class DiningController < ApplicationController
  # GET /products
  def index
    @products = Product.where(category: "dining")
    if params[:user_id]
      sort_by = User.find(params[:user_id]).sort_by
      sort_by == "price"? @products = @products.order(avg_price: :desc, name: :asc, number: :asc) : @products = @products.order(popularity: :desc, name: :asc, number: :asc)
      if User.find(params[:user_id]).scramble_numbers
        @products.each {|e| e.name = e.scramble_numbers}
      end
    end
    render json: @products
  end

  # GET /products/1
  def show
    pagenumber = params[:id].to_i
    min = (pagenumber - 1) * 6
    max = min + 5
    @products = Product.where(category: "dining")
    if params[:user_id]
      sort_by = User.find(params[:user_id]).sort_by
      sort_by == "price"? @products = @products.order(avg_price: :desc, name: :asc, number: :asc) : @products = @products.order(popularity: :desc, name: :asc, number: :asc)
      if User.find(params[:user_id]).scramble_numbers
        @products[min..max].each {|e| e.name = e.scramble_numbers}
      end
    end
    render json: {"products": @products[min..max], "pages": @products.length, "page_number": pagenumber}
  end
end
