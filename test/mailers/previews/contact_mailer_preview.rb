# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/contact_us
  def contact_us
    ContactMailer.contact_us
    name = "Pepe Argento"
    email = "pepe@argento.com.ar"
    subject = "Hola Fer"
    content = "Soy Pepe Argento y me pongo en contacto con vos, Fer!"
    ContactMailer.contact_us(name, email, subject, content)
  end
end
