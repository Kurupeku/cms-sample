class Article < ApplicationRecord
  # enum
  enum status: { draft: 0, published: 1 }
  enum article_type: { post: 0, static: 1 }

  # validations
  validates :title, presence: true
  validates :status, presence: true
  validates :article_type, presence: true
  validates :slug, presence: true, uniqueness: true

  # relations
  belongs_to :author, class_name: 'User'

  # use ActionText
  has_rich_text :content
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
