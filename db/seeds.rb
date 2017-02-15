# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

candidates_text = File.read(Rails.root.join('lib', 'seeds', 'candidates.json'))
candidates_json = ActiveSupport::JSON.decode(candidates_text)
candidates_json['candidates'].each do |candidate|
  c = Candidate.find_or_create_by(name: candidate['name'])
  c.office = candidate['office']
  c.questions = candidate['questions']
  c.save

  puts "#{c.office}: #{c.name} saved"
end

surveys_text = File.read(Rails.root.join('lib', 'seeds', 'surveys.json'))
surveys_json = ActiveSupport::JSON.decode(surveys_text)
surveys_json['surveys'].each do |survey|
  s = Survey.find_or_create_by(name: survey['name'])
  s.contents = survey['contents']
  s.save

  puts "#{s.name} saved"
end

members_text = File.read(Rails.root.join('lib', 'seeds', 'test_roster.csv'))
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
  m.save

  puts "#{m.databank_id}: #{m.first_name} #{m.last_name} saved"
end

puts "There are now #{Candidate.count} candidates."
puts "There are now #{Survey.count} surveys."
puts "There are now #{Member.count} members"

