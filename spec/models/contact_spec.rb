require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Contact, type: :model do
  context 'バリデーションの動作確認' do
    it 'name, email, content が有効な値の場合、有効になる' do
      contact = build :contact
      expect(contact).to be_valid
    end

    it 'name が未定義の場合、無効になる' do
      contact = build :contact, name: nil
      contact.valid?
      expect(contact.errors.key?(:name)).to be true
    end

    it 'name が空文字の場合、無効になる' do
      contact = build :contact, name: ''
      contact.valid?
      expect(contact.errors.key?(:name)).to be true
    end

    it 'email が未定義の場合、無効になる' do
      contact = build :contact, email: nil
      contact.valid?
      expect(contact.errors.key?(:email)).to be true
    end

    it 'email が空文字の場合、無効になる' do
      contact = build :contact, email: ''
      contact.valid?
      expect(contact.errors.key?(:email)).to be true
    end

    it 'email が無効な形式の場合、無効になる' do
      contact = build :contact, email: 'test.test.com'
      contact.valid?
      expect(contact.errors.key?(:email)).to be true
    end

    it 'content が未定義の場合、無効になる' do
      contact = build :contact, content: nil
      contact.valid?
      expect(contact.errors.key?(:content)).to be true
    end

    it 'content が空文字の場合、無効になる' do
      contact = build :contact, content: ''
      contact.valid?
      expect(contact.errors.key?(:content)).to be true
    end
  end
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
