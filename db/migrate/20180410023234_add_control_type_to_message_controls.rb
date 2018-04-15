class AddControlTypeToMessageControls < ActiveRecord::Migration[5.1]
  def change
    add_column :message_controls, :control_type, :string
  end
end
