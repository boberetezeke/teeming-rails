class AddEventTypeToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :event_type, :string
    add_column :events, :online_details, :text
  end
end
