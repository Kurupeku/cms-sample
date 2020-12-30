class ContactsController < ApplicationController
  def new; end

  def create
    puts contact_params
  end

  private

  def contact_params
    {
      name: params[:name],
      email: params[:email],
      content: params[:content]
    }
  end
end
