class Category < ApplicationRecord
  # validations
  validates :name, presence: true
  validate :not_has_children

  # relations
  belongs_to :parent, class_name: 'Category', foreign_key: 'parent_id', optional: true

  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :articles, dependent: :nullify

  def parent?
    children&.size&.positive? || false
  end

  def child?
    parent_id.present?
  end

  private

  def not_has_children
    return unless parent&.articles_count&.positive?

    errors.add :base, :not_have_children_and_articles
  end
end

# == Schema Information
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  articles_count :integer          default(0), not null
#  name           :string           default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :bigint
#
# Indexes
#
#  index_categories_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => categories.id)
#
