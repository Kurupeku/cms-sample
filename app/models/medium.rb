class Medium < ApplicationRecord
  has_one_attached :file

  def file_url
    return '' unless file.attached?

    Rails.application
         .routes.url_helpers
         .rails_representation_url file.variant({}), only_path: true
  end
end

# == Schema Information
#
# Table name: media
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
