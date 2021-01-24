require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Setting, type: :model do
  context 'バリデーションの動作確認' do
    it 'site_title, anable_main_cover, anable_recent_comments, anable_recent_popular, recent_popular_span が有効な値の場合、有効になる' do
      setting = build :setting
      expect(setting).to be_valid
    end

    it 'site_title が未定義の場合、無効になる' do
      setting = build :setting, site_title: nil
      setting.valid?
      expect(setting.errors.key?(:site_title)).to be true
    end

    it 'site_title が空文字の場合、無効になる' do
      setting = build :setting, site_title: ''
      setting.valid?
      expect(setting.errors.key?(:site_title)).to be true
    end

    it 'anable_main_cover が未定義の場合、無効になる' do
      setting = build :setting, anable_main_cover: nil
      setting.valid?
      expect(setting.errors.key?(:anable_main_cover)).to be true
    end

    it 'anable_recent_comments が未定義の場合、無効になる' do
      setting = build :setting, anable_recent_comments: nil
      setting.valid?
      expect(setting.errors.key?(:anable_recent_comments)).to be true
    end

    it 'anable_recent_popular が未定義の場合、無効になる' do
      setting = build :setting, anable_recent_popular: nil
      setting.valid?
      expect(setting.errors.key?(:anable_recent_popular)).to be true
    end

    it 'recent_popular_span が数値以外の場合、無効になる' do
      setting = build :setting, recent_popular_span: 'test'
      setting.valid?
      expect(setting.errors.key?(:recent_popular_span)).to be true
    end

    it 'mail_to がメールアドレス or "," 以外の場合、無効になる' do
      setting = build :setting, mail_to: 'test.test.com'
      setting.valid?
      expect(setting.errors.key?(:mail_to)).to be true
    end

    it 'mail_to がメールアドレス or "," の場合、有効になる' do
      setting = build :setting, mail_to: 'test@test.com,test@test.com'
      setting.valid?
      expect(setting).to be_valid
    end
  end
end

# == Schema Information
#
# Table name: settings
#
#  id                     :bigint           not null, primary key
#  anable_main_cover      :boolean          default(FALSE), not null
#  anable_recent_comments :boolean          default(FALSE), not null
#  anable_recent_popular  :boolean          default(FALSE), not null
#  mail_to                :string
#  recent_popular_span    :integer          default(7), not null
#  site_title             :string           default("Sample Blog"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
