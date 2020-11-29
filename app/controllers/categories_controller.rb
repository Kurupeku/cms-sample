class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show]

  # GET /categories
  def index
    @categories = Category.all
  end

  # GET /categories/1
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find params[:id]
  end

  # Only allow a trusted parameter "white list" through.
  def category_params
    params.require(:category).permit :parent_id, :name
  end
end
