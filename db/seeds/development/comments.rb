Article.published.post.each do |article|
  FactoryBot.create_list :comment, 2, article: article
  FactoryBot.create :comment, :with_children, article: article
  FactoryBot.create :comment, article: article
  FactoryBot.create :comment, :with_nested_children, article: article
end
