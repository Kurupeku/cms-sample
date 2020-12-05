class ApplicationController < ActionController::Base
  before_action :define_menu_variables

  def define_menu_variables
    @menus = [
      { label: 'All Posts', path:  root_path },
      { label: 'Categories', path: categories_path },
      { label: 'Tags', path: tags_path }
    ]
  end
end
