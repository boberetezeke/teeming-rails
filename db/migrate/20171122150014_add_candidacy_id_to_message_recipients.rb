class AddCandidacyIdToMessageRecipients < ActiveRecord::Migration[5.0]
  def change
    add_reference :message_recipients, :candidacy, index: true
  end
end
