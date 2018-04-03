class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chapter
  belongs_to :race
  belongs_to :election
  belongs_to :event
  has_many :message_recipients, dependent: :destroy
  belongs_to :member_group

  scope :for_chapter, ->(chapter) { where(chapter_id: chapter.id) }
  scope :sent,        ->{ where(Message.arel_table[:sent_at].not_eq(nil)) }

  validate :body_is_valid?

  def create_message_recipients
    self.message_recipients = []
    if race
      race.candidacies.each do |candidacy|
        self.message_recipients << MessageRecipient.new(candidacy: candidacy)
      end
    elsif election
      election.member_group.all_members(election.chapter).find_each do |member|
        self.message_recipients << MessageRecipient.new(member: member)
      end
    elsif event
      event.member_group.all_members(event.chapter).find_each do |member|
        self.message_recipients << MessageRecipient.new(member: member)
      end
    else
      member_group.all_members(chapter).find_each do |member|
        self.message_recipients << MessageRecipient.new(member: member)
      end
    end
  end

  def sent?
    sent_at.present?
  end

  def body_is_valid?
    render_errors = []
    rendered_body(nil, errors: render_errors)
    if render_errors.present?
      errors.add(:body, render_errors.map{|directive, error| "directive '#{directive}' #{error}"}.join(", "))
    end
  end

  def rendered_body(message_recipient, errors: [])
    host = Rails.application.config.action_mailer.default_url_options[:host]
    modified_body = body.gsub(/%(.[^%]*?)%/) do
      directive = $1
      case directive
        when /logo/
          "<div style=\"text-align: center;\"><a href=\"https://ourrevolutionmn.com\"><img width=\"250px\" height=\"250px\" src=\"https://ourrevolutionmn.herokuapp.com/images/logo-450.jpg\"></a></div>"
        when /recipient_name/
          if message_recipient
            message_recipient.name
          else
            ""
          end
        when /election_ballot_link/
          if election
            if election.offline_only?
              url = Rails.application.routes.url_helpers.election_path(election)
              "<a href=\"#{host}#{url}\">click to view in person election details</a>"
            else
              url = Rails.application.routes.url_helpers.election_votes_path(election)
              "<a href=\"#{host}#{url}\">click to vote</a>"
            end
          else
            errors.push(['election_link', "has no election associated with this message"])
            ""
          end
        when /event_link/
          if event
            url = Rails.application.routes.url_helpers.event_path(event)
            "<a href=\"#{host}#{url}\">#{event.name}</a>"
          else
            errors.push(['event_link', "has no event associated with this message"])
            ""
          end
        when /event_rsvp_link/
          if event
            if message_recipient
              user = message_recipient.member&.user
              if user
                url = Rails.application.routes.url_helpers.edit_event_rsvp_path(event.event_rsvps.for_user(user).first)
                "<a href=\"#{host}#{url}\">RSVP for #{event.name}</a>"
              else
                "Create a user account on https://ourrevolutionmn.com/members to RSVP to this event."
              end
            else
              ""
            end
          else
            errors.push(['event_rsvp_link', "has no event associated with this message"])
            ""
          end
        when /candidate_questionnaire_link/
          if message_recipient
            if message_recipient.candidacy
              url = Rails.application.routes.url_helpers.edit_candidate_questionnaire_path(message_recipient.candidacy.token)
              "<a href=\"#{host}#{url}\">candidate questionnaire</a>"
            else
              errors.push([candidate_questionnaire_link, "there is no candidacy associated with this message recipient"])
              ""
            end
          else
            ""
          end
        else
          errors.push([directive, "is unknown"])
      end
    end
    Kramdown::Document.new(modified_body).to_html.html_safe
  end
end
