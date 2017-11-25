class MembersMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def send_normal(message, from, message_recipient)
    @message = message
    @message_recipient = message_recipient
    mail(from: from,
         to: message_recipient.email,
         subject: message.subject)
  end
end