FactoryBot.define do
  factory :category do
    parent { nil }
    name { "MyString" }
  end
end

# == Schema Information
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  articles_count :string
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
