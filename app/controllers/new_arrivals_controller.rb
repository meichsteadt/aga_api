class NewArrivalsController < ApplicationController
  def index
    @products = Product.where("created_at >= ?", (DateTime.now - 90)).sort_by {|e| e.category}
    if params[:user_id]
      sort_by = User.find(params[:user_id]).sort_by
    end
    if params[:page_number]
      pagenumber = params[:page_number].to_i
      min = (pagenumber - 1) * 6
      max = min + 5
      render json: {"products": @products[min..max], "pages": @products.length, "page_number": pagenumber}
    else
      render json: @products.sort_by {|e| e.avg_price}.reverse.to_json
    end
  end
end
