class AddEventIdToMessages < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :event, index: true
  end
end
