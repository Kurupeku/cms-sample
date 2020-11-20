FactoryBot.define do
  factory :article do
    title { "MyString" }
    content { "MyText" }
    published_at { "2020-11-20 13:06:00" }
    status { 1 }
    type { 1 }
    slug { "MyString" }
  end
end
