crumb :root do
  link 'Home', root_path
end

crumb :article do |article|
  link article.title, article_path(article)
  parent :root, article
end

crumb :contact do
  link t('contacts.new.title'), '/contacts/new'
  parent :root
end

crumb :categories do
  link Category.model_name.human, categories_path
  parent :root
end

crumb :category do |category|
  link category.name, category_path(category)
  parent :categories
end

crumb :uncategorized do
  link t('utilities.uncategorized'), '/categories/0'
  parent :categories
end

crumb :tags do
  link Tag.model_name.human, tags_path
  parent :root
end

crumb :tag do |tag|
  link tag.name, tag_path(tag)
  parent :tags
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
