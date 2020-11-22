class Profile < ApplicationRecord
  # callbacks
  before_create :set_default_description

  # validations
  validates :name, presence: true

  # relations
  belongs_to :user, touch: true

  private

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
