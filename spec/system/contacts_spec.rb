require 'rails_helper'

RSpec.describe 'Contacts', type: :system do
  let(:setting) { create :setting }
  let(:contact_attributes) { attributes_for :contact }
  before do
    setting
  end

  context 'New' do
    let(:path) { new_contact_path }
    let(:body) { page.find 'body' }
    let(:contact_name_label) { Contact.human_attribute_name :name }
    let(:contact_email_label) { Contact.human_attribute_name :email }
    let(:contact_content_label) { Contact.human_attribute_name :content }
    let(:contact_submit_label) { I18n.t('buttons.submit') }
    before do
      visit path
    end

    it 'ページタイトルが適切であること' do
      expect(page).to have_title I18n.t('contacts.new.title')
    end

    it 'お問い合わせフォームが表示されていること' do
      expect(page).to have_content contact_name_label
      expect(page).to have_content contact_email_label
      expect(page).to have_content contact_content_label
      expect(page).to have_button contact_submit_label, disabled: true
    end

    it 'お問い合わせフォームの :name が入力されていないと submit が disabled になっていること' do
      fill_in contact_email_label, with: contact_attributes[:email]
      fill_in contact_content_label, with: contact_attributes[:content]
      body.click

      expect(page).to_not have_button contact_submit_label
    end

    it 'お問い合わせフォームの :email が適切な値でないと submit が disabled になっていること' do
      fill_in contact_name_label, with: contact_attributes[:name]
      fill_in contact_content_label, with: contact_attributes[:content]
      body.click
      expect(page).to_not have_button contact_submit_label

      fill_in contact_email_label, with: 'sample.sample.com'
      body.click
      expect(page).to_not have_button contact_submit_label
    end

    it 'お問い合わせフォームの :content が入力されていないと submit が disabled になっていること' do
      fill_in contact_name_label, with: contact_attributes[:name]
      fill_in contact_email_label, with: contact_attributes[:email]
      body.click

      expect(page).to_not have_button contact_submit_label
    end

    it 'お問い合わせフォームのすべてが入力されていると submit がクリック可能になっていること' do
      expect(page).to_not have_button contact_submit_label
      fill_in contact_name_label, with: contact_attributes[:name]
      fill_in contact_email_label, with: contact_attributes[:email]
      fill_in contact_content_label, with: contact_attributes[:content]
      body.click

      expect(page).to have_button contact_submit_label
    end
  end

  context 'Thanks' do
    let(:path) { thanks_contacts_path }
    before do
      visit path
    end

    it 'ページタイトルが適切であること' do
      expect(page).to have_title I18n.t('contacts.thanks.title')
    end

    it '適切なコンテンツが表示されていること' do
      expect(page).to have_content I18n.t('contacts.thanks.read')
      expect(page).to have_content I18n.t('contacts.thanks.content')
    end
  end
end
