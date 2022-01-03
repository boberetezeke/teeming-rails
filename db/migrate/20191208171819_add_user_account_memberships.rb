class AddUserAccountMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :user_account_memberships do |t|
      t.references :user, index: true
      t.references :account, index: true
    end
  end
end
