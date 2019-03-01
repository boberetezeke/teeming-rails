class MessageSendJob < ApplicationJob
  def perform(message_id)
    @message = Message.find(message_id)
    @message.send_to_all
  end
end
