class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  def index
    if params[:sub_category]
      if SubCategory.find(params[:sub_category])
        @products = SubCategory.find(params[:sub_category]).products
      end
    else
      @products = Product.all.sort_by {|e| e.id}
    end
    if params[:user_id]
      sort_by = User.find(params[:user_id]).sort_by
      sort_by == "price"? @products = @products.order(avg_price: :desc, name: :asc, number: :asc) : @products = @products.order(popularity: :desc, name: :asc, number: :asc)
    end
    if params[:page_number]
      pagenumber = params[:page_number].to_i
      min = (pagenumber - 1) * 6
      max = min + 5
      render json: {"products": @products[min..max], "pages": @products.length}
    else
      render json: {"products": @products, "pages": @products.length}
    end
  end

  # GET /products/1
  def show
    if params[:user_id]
      show_user_products(params)
    else
      render json: {"product": @product, "product_items": @product.product_items, "sub_categories": @product.sub_categories }
    end
  end

  def create
    if authenticate(params)
      @product = Product.new(product_params)
      if @product.save!
        if @product.images.length > 0
          @product.update(thumbnail: @product.images[0].gsub('homelegance', 'homelegance-resized'))
        end
        if params[:product][:product_items]
          product_item_params.each {|e| @product.product_items.create(e)}
          @product.get_avg_price
        end
        if params[:product][:sub_categories]
          sub_categories_params.each {|e| @product.sub_categories.push(SubCategory.find(e))}
        end
        render json: {"product": @product.as_json, "product_items": @product.product_items}
      else
        render json: {"message": "Something went wrong"}
      end
    else
      render json: {"message": "Unauthenticated"}
    end
  end

  def update
    if authenticate(params)
      @product = Product.find(params[:id])
      if @product.update(product_params)
        if params[:product][:product_items]
          product_item_params.each {|e| @product.product_items.find(e["id"]).update(e)}
        end
        if params[:product][:sub_categories]
          @product.sub_categories.delete_all
          sub_categories_params.each {|e| @product.sub_categories.push(SubCategory.find(e))}
        end
        render json: {"product": @product.as_json, "product_items": @product.product_items}
      else
        render json: {"message": "Something went wrong"}
      end
    else
      render json: {"message": "Unauthenticated"}
    end
  end

  def destroy
    if authenticate(params)
      @product = Product.find(params[:id])
      @product.product_items.destroy
      @product.destroy
      render json: 'Deleted successfully'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
      @product.update(popularity: @product.popularity + 1)
    end

    def show_user_products(params)
      product_items = []
      @user = User.find(params[:user_id])
      @product = Product.find(params[:id])
      multiplier = @user.multiplier(@product.category)
      @product.product_items.each do |item|
        unless multiplier.nil?
          item.price = item.get_price(@user) * multiplier
          if @user.round
            item.price = (((item.price/10.0).ceil) *10 )-1
          end
        else
          item.price = nil
        end
        product_items.push(item)
      end
      render json: {"product": @product, "product_items": product_items.sort_by {|item| item.price}.reverse}
    end

    def authenticate(params)
      key = Base64.decode64(request.headers["key"])
      secret = Base64.decode64(request.headers["secret"])
      if key == ENV['PRODUCT_KEY'] && secret == ENV['PRODUCT_SECRET']
        true
      else
        false
      end
    end

    def product_params
      params.require(:product).permit(:name, :number, :description, :category, :images => [])
    end

    def product_item_params
      params.require(:product).permit(:product_items => [:number, :dimensions, :description, :product_number, :price, :id])["product_items"]
    end

    def sub_categories_params
      params.require(:product).permit(:sub_categories => [])["sub_categories"]
    end
end
