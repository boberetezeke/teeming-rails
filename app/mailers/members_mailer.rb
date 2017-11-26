class MembersMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def send_normal(message, from, message_recipient)
    @message = message
    @message_recipient = message_recipient
    mail_options = {
        from: from,
        to: message_recipient.email,
        subject: message.subject
    }
    if ENV['OUTGOING_MAIL_BCC']
      mail_options[:bcc] = ENV['OUTGOING_MAIL_BCC']
    end
    mail(mail_options)
  end
end