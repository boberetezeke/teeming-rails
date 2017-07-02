require 'csv'

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

members_text = File.read(Rails.root.join('db', 'data', 'ormn_roster.csv'))
csv = CSV.parse(members_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  m = Member.find_or_create_by(databank_id:  row['MemberID'])
  m.first_name = row['First1']
  m.middle_initial = row['MI1']
  m.last_name = row['Last1']
  m.company = row['Company']
  m.address_1 = row['Address']
  m.address_2 = row['Addr2']
  m.city = row['City']
  m.state = row['State']
  m.zip = row['Zip']
  m.home_phone = row['HomePhone']
  m.work_phone = row['WorkPhone']
  m.mobile_phone = row['MobilePh']
  m.email = row['Email']
  m.save!

  puts "#{m.databank_id}: #{m.first_name} #{m.last_name} saved"
end

puts "There are now #{Member.count} members"


blocked_emails = []
bounced_emails = []
invalid_emails = []
unsubscribed_emails = []
duplicate_emails = []

blocks_text = File.read(
  Rails.root.join('db', 'data', 'suppressions', 'suppression_blocks.csv')
)
blocks = CSV.parse(blocks_text, :headers => true, :encoding => 'ISO-8859-1')
blocks.each { |row| blocked_emails.push(row['email'])}

bounces_text = File.read(
  Rails.root.join('db', 'data', 'suppressions', 'suppression_bounces.csv')
)
bounces = CSV.parse(bounces_text, :headers => true, :encoding => 'ISO-8859-1')
bounces.each { |row| bounced_emails.push(row['email'])}

spams_text = File.read(
  Rails.root.join('db', 'data', 'suppressions', 'suppression_spam_reports.csv')
)
spams = CSV.parse(spams_text, :headers => true, :encoding => 'ISO-8859-1')
spams.each { |row| bounced_emails.push(row['email'])}

invalids_text = File.read(
  Rails.root.join('db', 'data', 'suppressions', 'suppression_invalid_emails.csv')
)
invalids = CSV.parse(invalids_text, :headers => true, :encoding => 'ISO-8859-1')
invalids.each { |row| invalid_emails.push(row['email'])}

bad_emails_text = File.read(
  Rails.root.join('db', 'data', 'suppressions', 'bad_email_roster.csv')
)
bads = CSV.parse(bad_emails_text, :headers => true, :encoding => 'ISO-8859-1')
bads.each { |row| invalid_emails.push(row['email'])}

requests_text = File.read(
  Rails.root.join('db', 'data', 'suppressions', 'suppression_manual.csv')
)
requests = CSV.parse(requests_text, :headers => true, :encoding => 'ISO-8859-1')
requests.each { |row| unsubscribed_emails.push(row['email'])}

unsubscribe_text = File.read(
  Rails.root.join('db', 'data', 'suppressions', 'unsubscribe_roster.csv')
)
unsubscribes = CSV.parse(requests_text, :headers => true, :encoding => 'ISO-8859-1')
unsubscribes.each { |row| unsubscribed_emails.push(row['email'])}

blocked_emails.each do |email|
  member = Member.find_by_email(email)
  member.update(status: 'block') if member
end
puts "There are #{blocked_emails.count} blocked emails"

bounced_emails.each do |email|
  member = Member.find_by_email(email)
  member.update(status: 'bounce') if member
end
puts "There are #{bounced_emails.count} bounced emails"

unsubscribed_emails.each do |email|
  member = Member.find_by_email(email)
  member.update(status: 'unsubscribe') if member
end
puts "There are #{unsubscribed_emails.count} unsubscribed emails"

invalid_emails.each do |email|
  member = Member.find_by_email(email)
  member.update(status: 'invalid') if member
end

Member.valid_email.each do |member|
  if (member[:email] =~ VALID_EMAIL_REGEX).nil?
    member.update!(status: 'invalid')
  end
end
puts "There are #{invalid_emails.count} invalid emails"


repeated_emails = Member.valid_email.group(:email)
  .having("count(email) > 1").count.keys

repeated_emails.each do |email|
  Member.current.where(email: email)
    .order("databank_id desc")
    .each_with_index do |member, i|

    if i != 0
      member.update!(status: "duplicate")
      duplicate_emails.push(member[:email])
    end
  end
end
puts "There are #{duplicate_emails.count} duplicate emails"


Member.where("status IS NULL").each do |member|
  member.update!(status: "active")
end

puts "There are #{Member.active.count} active members!"

#======================== setup MN State Init ==========================

state_chapter = Chapter.find_or_create_by(name: 'State', is_state_wide: true)

initial_board_election = Election.find_or_create_by(name: 'Initial Board Election', chapter_id: state_chapter.id)
initial_board_race = Race.find_or_create_by(name: 'Initial Board Election Race', election_id: initial_board_election.id)
initial_board_questionnaire = Questionnaire.find_or_create_by(race_id: initial_board_race)
initial_board_questionnaire_question_1 = Question.find_or_create_by(questionnaire_id: initial_board_questionnaire, text: 'Why do you want to be one the board of directors')

