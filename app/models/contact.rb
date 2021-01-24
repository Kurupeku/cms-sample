class Contact < ApplicationRecord
  # validations
  validates :name, presence: true
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, format: { with: EMAIL_REGEX }
  validates :content, presence: true
end

# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  email      :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
