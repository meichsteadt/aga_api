class CategoriesController < ApplicationController
  before_action :authenticate_key, only: [:create, :update, :delete]
  before_action :set_sub_category, only: [:show, :edit, :update, :destroy]
  def index

  end

  def show
    render json: @sub_category
  end

  def create
    @sub_category = SubCategory.new(sub_category_params)
    if @sub_category.save!
      render json: {
        sub_category: @sub_category,
        status: 200,
        message: "sub category successfully created"
      }
    else
      render json: {

      }
    end
  end

  def update
    products = []
    product_params["products"].each do |id|
      products << Product.find(id)
    end
    if category_params[:method] == "add"
      @sub_category.products += products
    elsif category_params[:method] == "delete"
      @sub_category.products -= products
    end
    render json: {
      status: 202,
      message: "successfully updated products"
    }
  end

  def destroy
    if @sub_category.destroy!
      render json: {
        status: 202,
        message: "successfully deleted category"
      }
    else
      render json: {
        status: 400,
        message: "something went wrong"
      }
    end
  end

private
  def set_sub_category
    @sub_category = SubCategory.find(params[:id])
  end

  def category_params
    params.permit(:method)
  end

  def product_params
    params.require(:sub_category).permit(:products => [])
  end

  def sub_category_params
    params.require(:sub_category).permit(:name, :thumbnail, :parent_category)
  end
end
