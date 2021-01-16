class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show]
  before_action :set_default_ransack, only: %i[show]
  before_action :set_page_params, only: %i[show]

  # GET /categories
  def index
    @categories = @side_menu_categories || Category.positive_parent
  end

  # GET /categories/1
  def show
    define_side_menu_models
    @search = if @category.present?
                @category.articles.published.post
              else
                Article.published.post.where category_id: nil
              end.ransack params[:q]
    @articles = @search.result.page(@page).per(@per)
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = (Category.find params[:id] unless params[:id] == '0')
  end

  # Only allow a trusted parameter "white list" through.
  def category_params
    params.require(:category).permit :parent_id, :name
  end

  def set_default_ransack
    return if params[:q].present?

    params[:q] = {
      's' => {
        '0' => {
          'name' => 'published_at',
          'dir' => 'desc'
        }
      }
    }
  end

  def set_page_params
    @page = (params[:page] || 1).to_i
    @per = (params[:per] || 10).to_i
  end
end
