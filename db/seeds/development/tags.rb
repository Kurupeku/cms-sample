# frozen_string_literal: true

# 3.times.each do |_n|
#   tag = FactoryBot.create :tag
#   random = Random.rand(1..3)
#   article = Article.all.sample random
#   article[0] && article[0].tags << tag
# end

FactoryBot.create_list :tag, 3

Article.all.each do |article|
  random = Random.rand(1..3)
  tag = Tag.find_by id: random
  tag.articles << article
end
