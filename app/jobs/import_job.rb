class ImportJob < ApplicationJob
  def perform(current_user_id, file_attributes)
    sleep 10
    Member.import_file(file_attributes[:tempfile])
  end
end