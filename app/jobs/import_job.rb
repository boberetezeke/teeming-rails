class ImportJob < ApplicationJob
  def perform(current_user_id, account_id, importer_id)
    begin
    user = User.find(current_user_id)
    account = Account.find(account_id)
    importer = Importer.find(importer_id)
    Member.import_file(user, account, importer)
    rescue Exception => e
      puts "ERROR: #{e.message}"
      e.backtrace[0..3].each do |bt|
        puts "BACKTRACE: #{bt}"
      end
    end
  end
end