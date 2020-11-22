class Tag < ApplicationRecord
  # validations
  validates :name, presence: true

  # relations
  has_many :article_tag_attachments, dependent: :destroy
  has_many :articles, through: :article_tag_attachments
end

# == Schema Information
#
# Table name: tags
#
#  id             :bigint           not null, primary key
#  articles_count :integer          default(0), not null
#  name           :string           default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#