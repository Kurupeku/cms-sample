class ApplicationController < ActionController::Base
  before_action :define_menu_variables
  before_action :define_side_menu_models

  private

  def define_menu_variables
    @menus = [
      { label: t('utilities.all_posts'), path: root_path },
      { label: Category.model_name.human, path: categories_path },
      { label: Tag.model_name.human, path: tags_path }
    ]
  end

  def define_side_menu_models
    @side_menu_categories = Category.positive_parent
    @side_menu_tags = Tag.positive
  end
end
