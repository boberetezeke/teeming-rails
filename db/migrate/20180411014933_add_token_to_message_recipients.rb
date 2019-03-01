class AddTokenToMessageRecipients < ActiveRecord::Migration[5.1]
  def change
    add_column :message_recipients, :token, :string
  end
end
