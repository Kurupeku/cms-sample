class SettingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :site_title, :mail_to, :main_cover_url, :anable_main_cover,
             :anable_recent_comments, :anable_recent_popular, :recent_popular_span
end
