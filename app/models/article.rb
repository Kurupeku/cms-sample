class Article < ApplicationRecord
  # gem settings
  is_impressionable counter_cache: true, column_name: :impressions_count, unique: true

  # callbacks
  before_save :set_opening_sentence

  # enum
  enum status: { draft: 0, published: 1 }
  enum article_type: { post: 0, static: 1 }

  # validations
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :not_add_to_parent_category

  # relations
  belongs_to :author, class_name: 'User'
  belongs_to :category, optional: true, counter_cache: true

  has_many :comments, dependent: :destroy
  has_many :article_tag_attachments, dependent: :delete_all
  has_many :tags, through: :article_tag_attachments

  # use active storage
  has_one_attached :cover

  # use action text
  has_rich_text :content

  # overriting inherited method to use slug in url_helper
  def to_param
    slug
  end

  private

  def set_opening_sentence
    return if content&.body.blank?

    self.opening_sentence = content.body.to_plain_text.byteslice 0, 40
  end

  def not_add_to_parent_category
    errors.add :base, :not_have_children_and_articles if category.present? && category.parent?
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
