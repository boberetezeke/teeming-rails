class AddMemberNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :notes, :text
  end
end
