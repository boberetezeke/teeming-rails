class ImportJob < ApplicationJob
  def perform(current_user_id, importer_id)
    user = User.find(current_user_id)
    importer = Importer.find(importer_id)
    Member.import_file(user, importer)
  end
end