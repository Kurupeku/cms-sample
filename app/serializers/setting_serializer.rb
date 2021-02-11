class SettingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :site_title, :mail_to, :main_cover_url, :anable_main_cover,
             :anable_recent_comments, :anable_recent_popular, :recent_popular_span, :updated_at
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
