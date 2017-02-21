class VerifyMemberRoster < ActiveRecord::Migration[5.0]
  require 'csv'

  def up
    members_text = File.read(Rails.root.join('lib', 'seeds', 'ormn_roster.csv'))
    csv = CSV.parse(members_text, :headers => true, :encoding => 'ISO-8859-1')
    databank_ids = []
    csv.each { |row| databank_ids.push(row['MemberID'].to_i) }

    Member.all.each do |member|
      if databank_ids.include?(member.databank_id)
        member.update!(roster_status: 'present')
      else
        member.update!(roster_status: 'absent')
        member.update!(status: 'remove')
        puts "REMOVE #{member.databank_id} :: #{member.email}!"
      end
    end
  end

  def down
    Member.all.each do |member|
      member.update!(roster_status: nil)
    end
  end
end
