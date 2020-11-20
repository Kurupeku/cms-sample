class Article < ApplicationRecord
  # enum
  enum status: { draft: 0, published: 1 }
  enum article_type: { post: 0, static: 1 }

  # validations
  validates :title, presence: true
  validates :content, presence: true
  validates :status, presence: true
  validates :article_type, presence: true
  validates :slug, presence: true, uniqueness: true

  # relations
  belongs_to :author, class_name: 'User'
end
