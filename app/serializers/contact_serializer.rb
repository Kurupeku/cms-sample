class ContactSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :email, :content, :created_at, :updated_at
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
