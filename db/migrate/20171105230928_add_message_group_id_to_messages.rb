class AddMessageGroupIdToMessages < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :member_group, index: true
  end
end
