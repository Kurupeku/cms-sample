# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    article { create :article }
    user { nil }
    sequence(:author_name) { |n| "CommentAuthor#{n}" }
    status { 0 }
    author_ip { '192.168.0.1' }
    author_url { 'https://sample.com/' }
    author_agent do
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100'
    end
    content { 'テストのコメント内容です' }
  end

  factory :comment_by_user, parent: :comment do
    user { create :user }
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
