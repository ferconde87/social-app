require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "contact_us" do
    name = "Fernando"
    email = "fernando@example.com"
    subject = "This is a subject"
    content = "This is a content"
    mail = ContactMailer.contact_us(name, email, subject, content)
    assert_equal subject, mail.subject
    assert_equal ["ferconde87@gmail.com"], mail.to
    assert_equal [email], mail.from
    assert_match content, mail.body.encoded
  end
end
