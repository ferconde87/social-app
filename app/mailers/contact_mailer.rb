class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_us.subject
  #
  def contact_us(name, email, subject, content)
    @name = name
    @email = email
    @content = content
    mail to: "ferconde87@gmail.com", subject: subject, from: "#{name} <#{email}>"
  end
end
