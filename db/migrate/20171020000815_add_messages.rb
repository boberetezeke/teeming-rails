class AddMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :user, index: true
      t.string :subject
      t.string :body
      t.string :to
      t.string :message_type
    end

    create_table :message_recipients do |t|
      t.references :message, index: true
      t.references :member, index: true
    end

    create_table :message_controls do |t|
      t.references :member, index: true
      t.references :unsubscribed_from_message_id, index: true
      t.datetime :unsubscribed_at
      t.string :unsubscribe_reason
    end
  end
end
