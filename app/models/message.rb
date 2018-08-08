class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chapter
  belongs_to :race
  belongs_to :election
  belongs_to :event
  has_many :message_recipients, dependent: :destroy
  belongs_to :member_group

  scope :for_chapter,     ->(chapter) { where(chapter_id: chapter.id) }
  scope :sent,            ->{ where(Message.arel_table[:sent_at].not_eq(nil)) }
  scope :by_most_recent,  ->{ order('updated_at desc')}

  validate :body_is_valid?

  MESSAGE_TYPE_EVENT =      'event'
  MESSAGE_TYPE_GENERAL =    'general'
  MESSAGE_TYPE_CANDIDACY =  'candidacy'
  MESSAGE_TYPE_ELECTION =   'election'

  def message_recipients_for_show
    if sent_at
      message_recipients
    else
      message_recipients.unqueued
    end
  end

  def num_recipients
    if race
      members = race.candidacies
    elsif election
      members = election.member_group.all_members(election.chapter)
    elsif event
      members = event.member_group.all_members(event.chapter)
    else
      members = member_group.all_members(chapter)
    end

    members.sendable.count
  end

  def create_message_recipients(limit: nil, set_queued_at: false)
    self.message_recipients.where(queued_at: nil).destroy_all
    count = 0
    if race
      race.candidacies.each do |candidacy|
        if member.can_receive_message_for?(MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL, MESSAGE_TYPE_CANDIDACY)
          self.message_recipients << MessageRecipient.new(candidacy: candidacy, queued_at: set_queued_at ? Time.now : nil)
          count += 1; return if limit && count >= limit
        end
      end
    elsif election
      election.member_group.all_members(election.chapter).find_each do |member|
        if member.can_receive_message_for?(MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL, MESSAGE_TYPE_ELECTION)
          self.message_recipients << MessageRecipient.new(member: member, queued_at: set_queued_at ? Time.now : nil)
          count += 1; return if limit && count >= limit
        end
      end
    elsif event
      event.member_group.all_members(event.chapter).find_each do |member|
        if member.can_receive_message_for?(MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL, MESSAGE_TYPE_EVENT)
          self.message_recipients << MessageRecipient.new(member: member, queued_at: set_queued_at ? Time.now : nil)
          count += 1; return if limit && count >= limit
        end
      end
    else
      member_group.all_members(chapter).find_each do |member|
        if member.can_receive_message_for?(MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL, MESSAGE_TYPE_GENERAL)
          self.message_recipients << MessageRecipient.new(member: member, queued_at: set_queued_at ? Time.now : nil)
          count += 1; return if limit && count >= limit
        end
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

  def send_to_all
    create_message_recipients(set_queued_at: true)
    send_email(update_sent_at: true)
  end

  def send_email(update_sent_at: false)
    self.reload.message_recipients.each do |message_recipient|
      if race
        MembersMailer.delay.send_normal(self, "endorsements@ourrevolutionmn.com", message_recipient) # .deliver # .deliver_later
      else
        MembersMailer.delay.send_normal(self, "communications@ourrevolutionmn.com", message_recipient) #.deliver # .deliver_later
      end
    end
    update(sent_at: Time.now) if update_sent_at
  end


  def unsubscribe_footer(unsubscribe_path)
    "<hr/>" +
      "<p>You are receiving this email because your email preferences allow emails to be sent to you</p>" +
      "<p>" +
      "<a href=\"#{unsubscribe_path}\">You can unsubscribe by clicking on this link</a>" +
      "</p>"
  end

  def rendered_body(message_recipient, unsubscribe_path, errors: [])
    host = Rails.application.config.action_mailer.default_url_options[:host]
    modified_body = body.gsub(/%(.[^%]*?)%/) do
      directive = $1
      case directive
        when /logo/
          "<div style=\"text-align: center;\"><a href=\"https://ourrevolutionmn.com\"><img width=\"250px\" height=\"250px\" src=\"https://ourrevolutionmn.herokuapp.com/images/logo-450.jpg\"></a></div>"
        when /recipient_first_name/
          if message_recipient
            message_recipient.first_name
          else
            ""
          end
        when /recipient_last_name/
          if message_recipient
            message_recipient.last_name
          else
            ""
          end
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
                url = Rails.application.routes.url_helpers.event_path(event, goto_rsvp: true)
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

        when /event_description/
          if event && event.description.present?
            "#{Kramdown::Document.new(event.description).to_html}"
          else
            ""
          end

        when /event_agenda/
          if event && event.agenda.present?
            "#{Kramdown::Document.new(event.agenda).to_html}"
          else
            ""
          end

        when /event_online_details/
          if event && event.agenda.present?
            "#{Kramdown::Document.new(event.online_details).to_html}"
          else
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

    (Kramdown::Document.new(modified_body).to_html + unsubscribe_footer(unsubscribe_path)).html_safe
  end
end
