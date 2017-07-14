class AddUserToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_reference :answers, :user
  end
end
