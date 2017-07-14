class AddInfoToMembers < ActiveRecord::Migration[5.0]
  def change
    add_reference :members, :chapter
  end
end
