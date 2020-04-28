class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new params.require(:contact).permit(:name, :email, :subject, :phone, :message, :organization)
    if verify_recaptcha(model: @contact) && @contact.save
      ContactMailer.contact_email(@contact).deliver_now
      flash[:notice] = "Thanks! Your message has been sent."
      redirect_to root_path
    else
      flash[:errors] = "Oops did you fill out the form correctly?"
      render action: :new
    end
  end
end