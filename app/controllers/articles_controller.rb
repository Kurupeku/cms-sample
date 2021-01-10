class ArticlesController < ApplicationController
  impressionist actions: [:show]

  before_action :set_default_ransack, only: %i[index]
  before_action :set_page_params, only: %i[index]
  before_action :set_article_by_slug, only: %i[show]
  before_action :set_previous_and_next_article, only: %i[show]

  # GET /articles
  def index
    @search = Article.published.post.ransack params[:q]
    @articles = @search.result.page(@page).per(@per)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /articles/1
  def show
    @content_html = @article.content.html_safe
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article_by_slug
    @article = Article.published.post.find_by! slug: params[:id]
  end

  # Only allow a trusted parameter "white list" through.
  def article_params
    params.require(:article).permit :title, :article_type, :published_at,
                                    :status, :slug, :author_id, :category_id,
                                    :cover, :content
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

  def set_previous_and_next_article
    @previous_article = @article.previous
    @next_article = @article.next
  end
end
