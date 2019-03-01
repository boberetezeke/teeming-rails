class AddEmailToMessageRecipients < ActiveRecord::Migration[5.1]
  def change
    add_column :message_recipients, :email, :string
  end
end
