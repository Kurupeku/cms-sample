FactoryBot.define do
  factory :setting do
    site_title { 'Dev Blog' }
    mail_to { ENV['EMAIL_ADDRESS'] }
    anable_main_cover { false }
    anable_recent_comments { false }
    anable_recent_popular { false }
    recent_popular_span { 7 }
  end
end

# == Schema Information
#
# Table name: settings
#
#  id                     :bigint           not null, primary key
#  anable_main_cover      :boolean          default(FALSE), not null
#  anable_recent_comments :boolean          default(FALSE), not null
#  anable_recent_popular  :boolean          default(FALSE), not null
#  mail_to                :string
#  recent_popular_span    :integer          default(7), not null
#  site_title             :string           default("Sample Blog"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
