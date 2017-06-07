class ProductItemsController < ApplicationController
  before_action :set_product_item, only: [:show, :update, :destroy]

  # GET /product_items
  def index
    @product_items = ProductItem.all

    render json: @product_items
  end

  # GET /product_items/1
  def show
    render json: @product_item
  end

  # POST /product_items
  def create
    @product_item = ProductItem.new(product_item_params)

    if @product_item.save
      render json: @product_item, status: :created, location: @product_item
    else
      render json: @product_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_items/1
  def update
    if @product_item.update(product_item_params)
      render json: @product_item
    else
      render json: @product_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_items/1
  def destroy
    @product_item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_item
      @product_item = ProductItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_item_params
      params.fetch(:product_item, {})
    end
end
