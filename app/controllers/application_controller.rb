class ApplicationController < ActionController::Base
  prepend_before_action :set_setting
  before_action :define_menu_variables

  private

  def set_setting
    @setting = Setting.first
  end

  def define_menu_variables
    @menus = [
      { label: t('utilities.all_posts'), path: root_path },
      { label: Category.model_name.human, path: categories_path },
      { label: Tag.model_name.human, path: tags_path },
      *static_page_menus,
      { label: '問い合わせ', path: '/contacts' }
    ]
  end

  def static_page_menus
    Article.published.static.map do |article|
      { label: article.title, path: article_path(article) }
    end
  end

  def define_side_menu_models
    @side_menu = {
      categories: Category.positive_parent,
      uncategorized_articles_count: Article.where(category_id: nil).size,
      tags: Tag.positive,
      recent_popular_articles: Article.recent_populars(@setting.recent_popular_span, 5)
    }

    # @side_menu_categories = Category.positive_parent
    # @side_menu_uncategorized_articles_count = Article.where(category_id: nil).size
    # @side_menu_tags = Tag.positive
    # @recent_articles = Article.recent_populars @setting.recent_popular_span, 5
  end
end
