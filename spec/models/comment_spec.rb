require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
