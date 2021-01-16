require 'rails_helper'

RSpec.describe Setting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
