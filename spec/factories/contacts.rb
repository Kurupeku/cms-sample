FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "User#{n}" }
    sequence(:email) { |n| "test_#{n}@email.com" }
    content { 'テストの問い合わせ内容です' }
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  email      :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
