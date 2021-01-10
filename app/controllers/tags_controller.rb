class TagsController < ApplicationController
  before_action :set_tag, only: %i[show edit update destroy]
  before_action :set_default_ransack, only: %i[show]
  before_action :set_page_params, only: %i[show]

  # GET /tags
  def index
    @tags = @side_menu_tags || Tag.positive
  end

  # GET /tags/1
  def show
    @search = @tag.articles.published.post.ransack params[:q]
    @articles = @search.result.page(@page).per(@per)
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find params[:id]
  end

  # Only allow a trusted parameter "white list" through.
  def tag_params
    params.require(:tag).permit :name
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
