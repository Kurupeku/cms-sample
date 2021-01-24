class ContactMailer < ApplicationMailer
  before_action do
    @admin_mail = params[:mail_to] || ENV['EMAIL_ADDRESS']
  end
  before_action do
    @contact = params[:contact]
  end

  default from: ENV['EMAIL_ADDRESS']

  def send_mail_to_admin
    mail to: @admin_mail,
         subject: t('mailer.contact_mailer.admin.subject')
  end

  def send_mail_to_user
    mail to: @contact.email,
         subject: t('mailer.contact_mailer.user.subject')
  end
end
