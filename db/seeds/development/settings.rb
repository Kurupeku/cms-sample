# frozen_string_literal: true

new_attributes = {
  **Setting.first.attributes,
  **FactoryBot.attributes_for(:setting,
                              anable_recent_comments: true,
                              anable_recent_popular: true,
                              anable_main_cover: true)
              .delete_if { |key, _| key == :id }
}
setting = Setting.first
setting.update! new_attributes

main_cover_path = Rails.root.join 'public', 'main_cover_dev.jpg'
setting.main_cover.attach io: File.open(main_cover_path),
                          filename: 'main_cover_dev.jpg',
                          content_type: 'image/jpeg'
