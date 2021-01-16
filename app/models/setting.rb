class Setting < ApplicationRecord
  # validations
  validates :site_title, presence: true
  validates :anable_main_cover, inclusion: { in: [true, false] }
  validates :anable_recent_comments, inclusion: { in: [true, false] }
  validates :anable_recent_popular, inclusion: { in: [true, false] }
  validates :recent_popular_span, numericality: true

  # use active storage
  has_one_attached :main_cover
end

# == Schema Information
#
# Table name: settings
#
#  id                     :bigint           not null, primary key
#  anable_main_cover      :boolean          default(FALSE), not null
#  anable_recent_comments :boolean          default(FALSE), not null
#  anable_recent_popular  :boolean          default(FALSE), not null
#  recent_popular_span    :integer          default(7), not null
#  site_title             :string           default("Sample Blog"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
