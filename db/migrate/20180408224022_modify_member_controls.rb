class ModifyMemberControls < ActiveRecord::Migration[5.1]
  def up
    remove_index :message_controls, name: :index_message_controls_on_unsubscribed_from_message_id_id
    remove_column :message_controls, :unsubscribed_from_message_id_id
    add_column :message_controls, :unsubscribed_from_message_id, :integer
    add_index :message_controls, :unsubscribed_from_message_id

    add_column :message_controls, :unsubscribe_type, :string
  end

  def down
    remove_index :message_controls, name: :index_message_controls_on_unsubscribed_from_message_id
    remove_column :message_controls, :unsubscribed_from_message_id
    add_column :message_controls, :unsubscribed_from_message_id_id, :integer
    add_index :message_controls, :unsubscribed_from_message_id_id

    remove_column :message_controls, :unsubscribe_type
  end
end
