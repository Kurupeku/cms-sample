class Category < ApplicationRecord
  # validations
  validates :name, presence: true
  validate :not_has_children

  # relations
  belongs_to :parent, class_name: 'Category', foreign_key: 'parent_id', optional: true

  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :articles, dependent: :nullify

  # scope
  scope :joins_children, -> { left_outer_joins(:children).references(:children) }
  scope :has_children, lambda {
    left_outer_joins(:children)
      .references(:children)
      .where(parent_id: nil)
      .where('children_categories.parent_id > ?', 0)
  }
  scope :has_articles, lambda {
    left_outer_joins(:children)
      .references(:children)
      .where(parent_id: nil)
      .where('categories.articles_count > ?', 0)
  }
  scope :positive_parent, lambda {
    has_children.or(has_articles).order :articles_count
  }

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
