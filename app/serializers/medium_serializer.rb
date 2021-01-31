class MediumSerializer
  include FastJsonapi::ObjectSerializer
  attributes :file_url
end

# == Schema Information
#
# Table name: media
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
