# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    user { create :user }
    sequence(:name) { |n| "SampleUser#{n}" }
    description { 'これはテスト用の自己紹介文です。' }
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
