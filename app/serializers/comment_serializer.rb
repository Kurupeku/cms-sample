class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :user_id, :parent_id, :article_id, :author_name, :author_ip,
             :author_url, :author_agent, :content, :status, :number,
             :created_at, :updated_at
  has_many :children
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
