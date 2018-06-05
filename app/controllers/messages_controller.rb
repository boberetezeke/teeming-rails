class MessagesController < ApplicationController
  before_action :authenticate_user!
  include ActionView::Helpers::TextHelper

  before_action :set_context
  before_action :set_context_params

  def index
    authorize_with_args Message, @context_params
    @chapter = Chapter.find(params[:chapter_id])

    @messages = @chapter.messages
    @messages = policy_scope_with_args(@messages, @context_params)

    breadcrumbs [@chapter.name, @chapter], "Messages"
  end

  def show
    @message = Message.find(params[:id])
    authorize @message

    @race = @message.race
    @election = @message.election
    @event = @message.event

    @message.create_message_recipients if @message.message_recipients.blank?
    @message_recipient = @message.message_recipients.first

    breadcrumbs messages_breadcrumbs, truncate(@message.subject, length: 25)
  end

  def new
    authorize_with_args Message, @context_params

    if @race
      @chapter = @race.chapter
    elsif @election
      @chapter = @election.chapter
    elsif @event
      @chapter = @event.chapter
    else
      @chapters = Chapter.all
      @member_groups = MemberGroup.all
      @chapter = Chapter.find(params[:chapter_id])
    end
    @message = Message.new(chapter: @chapter, race: @race, election: @election, event: @event)
    breadcrumbs messages_breadcrumbs, "New Message"
  end

  def create
    @message = Message.new(message_params)
    authorize @message

    @message.save

    respond_with @message, location: ->{ params[:commit] == "Save Draft" ? chapter_messages_path(@message, @context_params) : message_path(@message, @context_params) }
  end

  def edit
    @message = Message.find(params[:id])

    authorize @message

    @member_groups = MemberGroup.all
    breadcrumbs messages_breadcrumbs, truncate("Edit #{@message.subject}", length: 25)
  end

  def update
    @message = Message.find(params[:id])
    authorize @message

    @message.update(message_params)

    respond_with @message, location: ->{ message_path(@message, @context_params) }
  end

  def send_to_all
    @message = Message.find(params[:id])
    @message.create_message_recipients
    send_email(update_sent_at: true)
    redirect_to chapter_messages_path(@message.chapter)
  end

  def preview_to
    @message = Message.find(params[:id])

    emails = params[:emails].split(/\s*[;,]\s*/).map{|email| email.strip}
    if emails.size == 0
      flash[:alert] = "No emails supplied to preview to"
    else
      @message.message_recipients = emails.map{|email| MessageRecipient.new(email: email)}
      send_email
    end

    redirect_to message_path(@message, @context_params)
  end

  def destroy
    @message = Message.find(params[:id])
    authorize @message

    race = @message.race

    @message.destroy

    if race
      redirect_to race_path(race, @context_params)
    else
      redirect_to chapter_messages_path(@context_params)
    end
  end

  private

  def send_email(update_sent_at: false)
    @message.reload.message_recipients.each do |message_recipient|
      if @message.race
        MembersMailer.delay.send_normal(@message, "endorsements@ourrevolutionmn.com", message_recipient) # .deliver # .deliver_later
      else
        MembersMailer.delay.send_normal(@message, "communications@ourrevolutionmn.com", message_recipient) #.deliver # .deliver_later
      end
    end
    @message.update(sent_at: Time.now) if update_sent_at
    flash[:notice] = "Message sent to #{@message.message_recipients.count} recipients"
  end

  def set_context
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id].present?
    @race = Race.find(params[:race_id]) if params[:race_id].present?
    @election = Election.find(params[:election_id]) if params[:election_id].present?
    @event = Event.find(params[:event_id]) if params[:event_id].present?
  end

  def set_context_params
    # @chapter_id = @chapter.id if @chapter
    @context_params = {}
    @context_params.merge!(@chapter ? { chapter_id: @chapter.id } : {})
    @context_params.merge!(@race ? { race_id: @race.id } : {})
    @context_params.merge!(@election ? { election_id: @election.id } : {})
    @context_params.merge!(@event ? { event_id: @event.id } : {})
  end

  def message_params
    params.require(:message).permit(:subject, :body, :member_group_id, :chapter_id, :race_id, :election_id, :event_id)
  end

  def messages_breadcrumbs(include_link: true)
    if @race
      [@race.complete_name, race_path(@race, @context_params)]
    elsif @election
      [@election.name, election_path(@election, @context_params)]
    elsif @event
      [@event.name, event_path(@event, @context_params)]
    else
      ["Messages", include_link ? chapter_messages_path(@chapter) : nil]
    end
  end
end
