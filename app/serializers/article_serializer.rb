class ArticleSerializer
  include FastJsonapi::ObjectSerializer
  attributes :slug, :author_id, :category_id, :status, :cover_url, :title, :content,
             :opening_sentence, :article_type, :published_at, :created_at, :updated_at
  has_many :comments
  has_many :tags
end

# == Schema Information
#
# Table name: articles
#
#  id                :bigint           not null, primary key
#  article_type      :integer          default("post"), not null
#  comments_count    :integer          default(0), not null
#  content           :text             default(""), not null
#  impressions_count :integer          default(0), not null
#  opening_sentence  :string           default("")
#  position          :integer
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
