FactoryBot.define do
  factory :tag do
    name { "MyString" }
  end
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