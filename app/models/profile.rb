class Profile < ApplicationRecord
  # callbacks
  before_validation :set_default_name
  before_create :set_default_description

  # validations
  validates :name, presence: true

  # relations
  belongs_to :user, touch: true

  # use active storage
  has_one_attached :avatar

  def avatar_url
    return '' unless avatar.attached?

    Rails.application
         .routes.url_helpers
         .rails_representation_url avatar.variant({}), only_path: true
  end

  private

  def set_default_name
    return if name.present?

    self.name = "User #{user_id}"
  end

  def set_default_description
    return if description.present?

    self.description = ''
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
