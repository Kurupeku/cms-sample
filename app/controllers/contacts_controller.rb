class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new contact_params
    if @contact.save
      mailer = ContactMailer.with mail_to: @setting.mail_to, contact: @contact
      mailer.send_mail_to_admin.deliver
      mailer.send_mail_to_user.deliver
      redirect_to thanks_contacts_path
    else
      render action: :new
    end
  end

  def thanks; end

  private

  def contact_params
    params.require(:contact).permit :name, :email, :content
  end
end
