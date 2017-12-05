class SubCategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def index
    @sub_categories = SubCategory.all
    render json: @sub_categories
  end

  def show
    if params[:page_number]
      unless params[:page_number] == "1"
        min = ((params[:page_number].to_i - 1) * 6) - 1
        max = min + 5
      else
        min = (params[:page_number].to_i - 1) * 6
        max = min + 4
      end
      @sub_categories = SubCategory.where(parent_category: @category).sort[min..max]
    else
      @sub_categories = SubCategory.where(parent_category: @category).sort
    end
    render json: {"sub_categories": @sub_categories, "pages": SubCategory.where(parent_category: @category).length}
  end

private
  def set_category
    @category = params[:category]
  end
end
