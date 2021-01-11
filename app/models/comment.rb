class Comment < ApplicationRecord
  # callbacks
  before_validation :set_unknown_author_name
  before_save :set_number_for_article

  # enum
  enum status: { published: 0, unpublished: 1 }

  # validations
  validates :author_name, presence: true
  INCLUDE_JAPANESE_REGEXP = /\A.*[亜-熙ぁ-んァ-ヶ]+.*\z/.freeze
  validates :content, presence: true, format: { with: INCLUDE_JAPANESE_REGEXP }
  validates :status, presence: true

  # relations
  belongs_to :article, counter_cache: true
  belongs_to :user, optional: true
  belongs_to :parent, class_name: 'Comment', foreign_key: 'parent_id', optional: true

  has_many :children, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  # scope
  scope :sorted_by_created_at, lambda {
    order(created_at: :asc)
  }

  scope :primary, lambda {
    left_outer_joins(:children)
      .references(:children)
      .where(parent_id: nil)
  }

  def replies
    children
  end

  def replies?
    children.size.positive?
  end

  def analysis_request_informations(request)
    self.author_url = request&.url || 'unknown'
    self.author_ip = request&.remote_ip || 'unknown'
    self.author_agent = request&.user_agent || 'unknown'
  end

  def check_current_user(current_user)
    return if current_user.blank?

    self.user = current_user
  end

  private

  def set_unknown_author_name
    return if author_name.present?

    self.author_name = '匿名ユーザー'
  end

  def set_number_for_article
    return if article_id.blank?

    article_comments = Comment.where article_id: article_id
    self.number = if article_comments.size.positive?
                    article_comments.maximum :number
                  else
                    0
                  end + 1
  end
end

# == Schema Information
#
# Table name: comments
#
#  id           :bigint           not null, primary key
#  author_agent :string           default(""), not null
#  author_ip    :string           default(""), not null
#  author_name  :string           default(""), not null
#  author_url   :string           default(""), not null
#  content      :text             default(""), not null
#  number       :integer
#  status       :integer          default("published"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  article_id   :bigint           not null
#  parent_id    :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_parent_id   (parent_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (parent_id => comments.id)
#  fk_rails_...  (user_id => users.id)
#
