require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe User, type: :model do
  context 'バリデーションの動作確認' do
    it 'email, password ともに有効な値の場合、有効になる' do
      user = build :user
      expect(user).to be_valid
    end

    it 'email が未定義の場合、無効になる' do
      user = build :user, email: nil
      user.valid?
      expect(user.errors.key?(:email)).to be true
    end

    it 'email の形式が正しくない場合、無効になる' do
      user = build :user, email: 'sample.mail.test.com'
      user.valid?
      expect(user.errors.key?(:email)).to be true
    end

    it 'password が未定義の場合、無効になる' do
      user = build :user, password: nil
      user.valid?
      expect(user.errors.key?(:password)).to be true
    end

    it 'password が6文字未満の場合、無効になる' do
      user = build :user, password: 'abced'
      user.valid?
      expect(user.errors.key?(:password)).to be true
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
