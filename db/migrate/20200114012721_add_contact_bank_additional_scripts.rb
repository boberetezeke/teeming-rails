class AddContactBankAdditionalScripts < ActiveRecord::Migration[5.2]
  def change
    add_column :contact_banks, :email_script, :text
    add_column :contact_banks, :sms_script, :text
  end
end
