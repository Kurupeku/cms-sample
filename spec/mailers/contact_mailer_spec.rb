require 'rails_helper'

RSpec.describe ContactMailer, type: :mailer do
  let(:setting) { create :setting }
  let(:contact) { create :contact }

  context 'send_mail_to_admin の動作確認' do
    subject(:send_mail_to_admin) do
      ContactMailer.with(mail_to: setting.mail_to, contact: contact)
                   .send_mail_to_admin
                   .deliver_now
      ActionMailer::Base.deliveries.last
    end

    it 'from のチェック' do
      expect(send_mail_to_admin.from.first).to eq ENV['EMAIL_ADDRESS']
    end

    it 'to のチェック' do
      expect(send_mail_to_admin.to.first).to eq setting.mail_to
    end

    it 'subject のチェック' do
      expect(send_mail_to_admin.subject).to eq I18n.t('mailer.contact_mailer.admin.subject')
    end

    it 'body のチェック' do
      body_text = <<~TEXT
        #{I18n.t 'mailer.contact_mailer.admin.from_text', name: contact.name}

        [#{I18n.t 'mailer.contact_mailer.common.email'}]
        #{contact.email}

        [#{I18n.t 'mailer.contact_mailer.common.content'}]
        #{contact.content}
      TEXT

      expect(send_mail_to_admin.body.raw_source.gsub(/\R/, '')).to eq body_text.gsub(/\R/, '')
    end
  end
end
