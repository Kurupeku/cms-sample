FactoryBot.define do
  factory :article_tag_attachment do
    article { nil }
    tag { nil }
  end
end

# == Schema Information
#
# Table name: article_tag_attachments
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  tag_id     :bigint           not null
#
# Indexes
#
#  index_article_tag_attachments_on_article_id  (article_id)
#  index_article_tag_attachments_on_tag_id      (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (tag_id => tags.id)
#
