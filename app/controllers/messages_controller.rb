class MessagesController < ApplicationController
  before_filter :authenticate_user!
  include ActionView::Helpers::TextHelper

  def index
    authorize Message
    @chapter = Chapter.find(params[:chapter_id])

    @messages = policy_scope(Message)
    @messages = @messages.for_chapter(@chapter)

    breadcrumbs [@chapter.name, @chapter], "Messages"
  end

  def show
    @message = Message.find(params[:id])
    authorize @message

    breadcrumbs messages_breadcrumbs, truncate(@message.subject, length: 25)
  end

  def new
    authorize Message

    @chapter = Chapter.find(params[:chapter_id])
    @message = Message.new(chapter: @chapter)
    @member_groups = MemberGroup.all
    breadcrumbs messages_breadcrumbs, "New Message"
  end

  def create
    @message = Message.new(message_params)
    authorize @message

    @message.save

    if params[:commit] == "Send"
      if @message.valid?
        @message.create_message_recipients
        @message.reload.message_recipients.each do |message_recipient|
          MembersMailer.send_normal(@message, message_recipient.member).deliver_later
        end
      end
    end
    respond_with @message
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

    respond_with @message
  end

  private

  def message_params
    params.require(:message).permit(:subject, :body, :member_group_id)
  end

  def messages_breadcrumbs(include_link: true)
    ["Messages", include_link ? chapter_messages_path(@message.chapter) : nil]
  end
end
