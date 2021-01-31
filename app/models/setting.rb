class Setting < ApplicationRecord
  # validations
  validates :site_title, presence: true
  validates :anable_main_cover, inclusion: { in: [true, false] }
  validates :anable_recent_comments, inclusion: { in: [true, false] }
  validates :anable_recent_popular, inclusion: { in: [true, false] }
  validates :recent_popular_span, numericality: { only_integer: true }
  EMAIL_TO_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+(,[\w+\-.]+@[a-z\d\-.]+\.[a-z]+)*\z/i.freeze
  validates :mail_to, format: { with: EMAIL_TO_REGEX }

  # use active storage
  has_one_attached :main_cover

  def main_cover_url
    return '' unless main_cover.attached?

    Rails.application
         .routes.url_helpers
         .rails_representation_url main_cover.variant({}), only_path: true
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
