class MembersMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def send_normal(message, member)
    @message = message
    @memeber = member
    mail(from: 'communications@ourrevolutionmn.com',
         to: member.email,
         subject: message.subject)
  end
end