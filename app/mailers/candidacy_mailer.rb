class CandidacyMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def send_normal(message, candidacy)
    @candidacy = candidacy
    @member = member
    mail(from: 'endorsements@ourrevolutionmn.com',
         to: candidacy.email,
         subject: message.subject)
  end
end