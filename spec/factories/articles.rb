FactoryBot.define do
  factory :article do
    title { "MyString" }
    content { "MyText" }
    published_at { "2020-11-20 13:06:00" }
    status { 1 }
    type { 1 }
    slug { "MyString" }
  end
end

# == Schema Information
#
# Table name: articles
#
#  id           :bigint           not null, primary key
#  article_type :integer          default("post"), not null
#  published_at :datetime
#  slug         :string           not null
#  status       :integer          default("draft"), not null
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :bigint
#
# Indexes
#
#  index_articles_on_author_id     (author_id)
#  index_articles_on_published_at  (published_at)
#  index_articles_on_slug          (slug)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
