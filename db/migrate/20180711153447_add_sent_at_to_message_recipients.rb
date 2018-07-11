class AddSentAtToMessageRecipients < ActiveRecord::Migration[5.1]
  def change
    add_column :message_recipients, :queued_at, :datetime
    add_column :message_recipients, :sent_at, :datetime
  end
end
