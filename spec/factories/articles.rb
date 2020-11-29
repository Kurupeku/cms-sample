# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    author { create :user }
    category { nil }
    sequence(:title) { |n| "Article #{n}" }
    content { 'テストの投稿内容です。' }
    published_at { Time.current }
    status { 0 }
    article_type { 0 }
    sequence(:slug) { |n| "slug-#{n}" }

    trait :with_category do
      category { create :category }
    end

    trait :with_comments do
      after :create do |article|
        random = Random.rand 0..10
        create_list :comment, random, article: article
      end
    end
  end
end

# == Schema Information
#
# Table name: articles
#
#  id                :bigint           not null, primary key
#  article_type      :integer          default("post"), not null
#  comments_count    :integer          default(0), not null
#  impressions_count :integer          default(0), not null
#  opening_sentence  :string           default("")
#  published_at      :datetime
#  slug              :string           not null
#  status            :integer          default("draft"), not null
#  title             :string           default(""), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  author_id         :bigint
#  category_id       :bigint
#
# Indexes
#
#  index_articles_on_author_id     (author_id)
#  index_articles_on_category_id   (category_id)
#  index_articles_on_published_at  (published_at)
#  index_articles_on_slug          (slug)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (category_id => categories.id)
#
