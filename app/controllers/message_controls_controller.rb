class MessageControlsController < ApplicationController
  def show
    @message_recipient = MessageRecipient.find_by_token(params[:id])
    @message_control = @message_recipient.member.message_control_for(MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL)

    authorize @message_control
  end

  def create
    @message_control = MessageControl.new(message_control_params)
    @message_recipient = MessageRecipient.find(params[:message_recipient_id])

    authorize @message_control

    if @message_control.save
      redirect_to message_control_path(@message_recipient.token)
    else
      render :edit
    end
  end

  def edit
    @message_recipient = MessageRecipient.find_by_token(params[:id])
    @message_control =  @message_recipient.member.message_control_for(MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL)
    @message_control = MessageControl.new(member: @message_recipient.member, unsubscribe_type: MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL) unless @message_control

    authorize @message_control
  end

  def update
    @message_control = MessageControl.find(params[:id])
    @message_recipient = MessageRecipient.find(params[:message_recipient_id])

    authorize @message_control

    if @message_control.update(message_control_params)
      redirect_to message_control_path(@message_recipient.token)
    else
      render :edit
    end
  end

  private

  def message_control_params
    params.require(:message_control).permit(:unsubscribe_type, :control_type, :unsubscribe_reason, :member_id)
  end
end
# Dylan 204-391-8109