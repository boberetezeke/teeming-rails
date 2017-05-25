class MemberMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid

  def send_member_email(member)
    mail = Mail.new
    mail.from = Email.new(email: ENV['SENDGRID_EMAIL'])

    personalization = Personalization.new
    personalization.to = Email.new(email: member.email)
    personalization.substitutions =
      Substitution.new(key: '%email%', value: member.email)

    mail.personalizations = personalization
    mail.contents = Content.new(type: 'text/html', value: 'template goes here')
    mail.template_id = ENV['SENDGRID_TEMPLATE_ID']

    sg = SendGrid::API.new(
      api_key: ENV['SENDGRID_API_KEY'],
      host: 'https://api.sendgrid.com'
    )
    sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
