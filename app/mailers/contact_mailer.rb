class ContactMailer < ApplicationMailer
  def contact_email(contact)
    @contact = contact
    mail subject: "[HISTORYFORGE] #{@contact.subject}", to: ENV['CONTACT_EMAIL'], reply_to: @contact.email
  end
end