require 'rails_helper'

RSpec.describe Profile, type: :model do
  context 'バリデーションの動作確認' do
    it 'user, name がともに有効な値の場合、有効になる' do
      profile = build :profile
      expect(profile).to be_valid
    end

    it 'user が存在しない場合、無効になる' do
      profile = build :profile, user: nil
      profile.valid?
      expect(profile.errors.key?(:user)).to be true
    end

    it 'name が未定義の場合、無効になる' do
      profile = build :profile, name: nil
      profile.valid?
      expect(profile.errors.key?(:name)).to be true
    end

    it 'name が空文字の場合、無効になる' do
      profile = build :profile, name: ''
      profile.valid?
      expect(profile.errors.key?(:name)).to be true
    end
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
