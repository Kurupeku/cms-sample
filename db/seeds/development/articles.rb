# frozen_string_literal: true

user = FactoryBot.create :user, :user_with_profile

category_a = FactoryBot.create :category
FactoryBot.create_list :article, 5, :with_comments, author: user, category: category_a

category_b = FactoryBot.create :category, :with_parent
FactoryBot.create_list :article, 3, :with_comments, author: user, category: category_b