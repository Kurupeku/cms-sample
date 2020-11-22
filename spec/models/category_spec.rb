require 'rails_helper'

RSpec.describe Category, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  articles_count :string
#  name           :string           default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :bigint
#
# Indexes
#
#  index_categories_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => categories.id)
#
