class VerifyMemberRoster < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :roster_status, :string
  end

  def up
    members_text = File.read(Rails.root.join('lib', 'seeds', 'ormn_roster.csv'))
    csv = CSV.parse(members_text, :headers => true, :encoding => 'ISO-8859-1')
    databank_ids = []
    csv.each { |row| databank_ids.push(row['MemberID'].to_i) }

    Member.all.each do |member|
      # flag is removed if absent from roster
      if databank_ids.include?(member.databank_id)
        member.update(roster_status: 'present')
      else
        member.update(roster_status: 'absent')
        member.update(status: 'remove')
        puts "REMOVE #{member.databank_id} :: #{member.email}!"
      end
    end
  end
end
