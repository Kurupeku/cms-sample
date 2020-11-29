class ArticlesController < ApplicationController
  impressionist actions: [:show]

  before_action :set_article_by_slug, only: %i[show]

  # GET /articles
  def index
    @articles = Article.all
  end

  # GET /articles/1
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article_by_slug
    @article = Article.find_by! slug: params[:id]
  end

  # Only allow a trusted parameter "white list" through.
  def article_params
    params.require(:article).permit :title, :article_type, :published_at,
                                    :status, :slug, :author_id, :category_id,
                                    :content
  end
end
