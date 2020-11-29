# frozen_string_literal: true

3.times.each do |_n|
  tag = FactoryBot.create :tag
  random = Random.rand(1..3)
  article = Article.all.sample random
  article[0] && article[0].tags << tag
end
