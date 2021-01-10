# frozen_string_literal: true

user = FactoryBot.create :user, :user_with_profile

category_a = FactoryBot.create :category
FactoryBot.create_list :article, 5,
                       :with_comments, author: user, category: category_a, status: :published

category_b = FactoryBot.create :category, :with_parent
FactoryBot.create_list :article, 3,
                       :with_comments, author: user, category: category_b, status: :published

category_c = FactoryBot.create :category
FactoryBot.create_list :article, 10,
                       :with_comments, author: user, category: category_c, status: :published

FactoryBot.create_list :article, 17,
                       status: :published

def generate_cover
  img_name = %w[sample_cover_1 sample_cover_2 sample_cover_3][rand(0..2)]
  path = Rails.root.join 'public', "#{img_name}.jpg"
  io = File.open path
  { io: io, filename: "#{img_name}.jpg", content_type: 'image/jpeg' }
end

Article.all.each do |article|
  article.cover.attach generate_cover
end
