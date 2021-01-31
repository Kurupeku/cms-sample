class CategorySerializer
  include FastJsonapi::ObjectSerializer
  attributes :parent_id, :name, :articles_count, :created_at, :updated_at
  has_many :children
  has_many :articles
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
