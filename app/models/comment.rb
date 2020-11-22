class Comment < ApplicationRecord
  # callbacks
  before_validation :set_unknown_author_name

  # enum
  enum status: { published: 0, unpublished: 1 }

  # validations
  validates :author_name, presence: true
  validates :content, presence: true
  validates :status, inclusion: { in: statuses.entries.flatten }

  # relations
  belongs_to :article, counter_cache: true
  belongs_to :user, optional: true

  def analysis_request_informations(request)
    self.author_url = request.url || 'unknown'
    self.author_ip = request.remote_ip || 'unknown'
    self.author_agent = request.user_agent || 'unknown'
  end

  def check_current_user(current_user)
    return if current_user.blank?

    self.user_id = current_user.id
  end

  private

  def set_unknown_author_name
    return if author_name.present?

    self.author_name = '匿名ユーザー'
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
#  status       :integer          default("published"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  article_id   :bigint           not null
#  user_id      :bigint
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
