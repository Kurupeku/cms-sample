# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    parent { nil }
    sequence(:name) { |n| "Category#{n}" }

    trait :with_parent do
      parent { create :category }
    end

    trait :with_children do
      after :create do |category|
        category.children << create(:category)
      end
    end

    trait :with_articles do
      after :create do |category|
        category.articles << create(:article)
      end
    end
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
