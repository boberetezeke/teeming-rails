class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chapter
  belongs_to :race
  belongs_to :election
  has_many :message_recipients
  belongs_to :member_group

  scope :for_chapter, ->(chapter) { where(chapter_id: chapter.id) }

  def create_message_recipients
    self.message_recipients = []
    if race
      race.candidacies.each do |candidacy|
        self.message_recipients << MessageRecipient.new(candidacy: candidacy)
      end
    elsif election
    else
      member_group.all_members(chapter).find_each do |member|
        self.message_recipients << MessageRecipient.new(member: member)
      end
    end
  end

  def sent?
    sent_at.present?
  end

  def rendered_body(message_recipient)
    modified_body = body.gsub(/%(.[^%]*?)%/) do
      case $1
        when /logo/
          "<div style=\"text-align: center;\"><a href=\"https://ourrevolutionmn.com\"><img width=\"250px\" height=\"250px\" src=\"https://ourrevolutionmn.herokuapp.com/images/logo-450.jpg\"></a></div>"
        when /recipient_name/
          message_recipient.name
        when /candidate_questionnaire_link/
          if message_recipient.candidacy
            host = Rails.application.config.action_mailer.default_url_options[:host]
            url = Rails.application.routes.url_helpers.edit_candidate_questionnaire_path(message_recipient.candidacy.token)
            "<a href=\"#{host}#{url}\">candidate questionnaire</a>"
          end
      end
    end
    puts "modified_body = #{modified_body}"
    Kramdown::Document.new(modified_body).to_html.html_safe
  end
end
