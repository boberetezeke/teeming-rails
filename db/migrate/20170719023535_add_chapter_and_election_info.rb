class AddChapterAndElectionInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :elections, :vote_date, :date
    rename_column :races, :entry_deadline, :filing_deadline_date
    add_column :races, :candidates_announcement_date, :date
  end
end
