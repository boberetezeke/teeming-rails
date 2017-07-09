require 'csv'

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

if File.exist?(Rails.root.join('db', 'data', 'ormn_roster.csv'))
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
end

#======================== setup MN State Init ==========================

state_chapter = Chapter.find_or_create_by(name: 'State', is_state_wide: true)

initial_board_election = Election.find_or_create_by(name: 'Initial Board Election', chapter_id: state_chapter.id)
initial_board_race = Race.find_or_create_by(name: 'Initial Board Election Race', election_id: initial_board_election.id, entry_deadline: Time.local(2017, 8, 5))
initial_board_questionnaire = Questionnaire.where(questionnairable_type: 'Race', questionnairable_id: initial_board_race.id).first

initial_board_questionnaire.destroy if initial_board_questionnaire
# if !initial_board_questionnaire
  initial_board_questionnaire = Questionnaire.create(questionnairable: initial_board_race)
  overview_section = QuestionnaireSection.create(questionnaire: initial_board_questionnaire, order: 1, title: 'Overview')
    Question.create(questionnaire_section: overview_section, order: 1, text: 'Campaign website', question_type: Question::QUESTION_TYPE_SHORT_TEXT)
    congressional_question = Question.create(questionnaire_section: overview_section, order: 2, text: 'For the purpose of fulfilling balance requirements put forth in the Our Revolution MN bylaws, specify your congressional district', question_type: Question::QUESTION_TYPE_MULTIPLE_CHOICE)
      Choice.create(question: congressional_question, order: 1, title: 'District 1, represented by Tim Walz',         value: '1')
      Choice.create(question: congressional_question, order: 2, title: 'District 2, represented by Jason Lewis',      value: '2')
      Choice.create(question: congressional_question, order: 3, title: 'District 3, represented by Erik Paulsen',     value: '3')
      Choice.create(question: congressional_question, order: 4, title: 'District 4, represented by Betty McCollum',   value: '4')
      Choice.create(question: congressional_question, order: 5, title: 'District 5, represented by Keith Ellison',    value: '5')
      Choice.create(question: congressional_question, order: 6, title: 'District 6, represented by Tom Emmer',        value: '6')
      Choice.create(question: congressional_question, order: 7, title: 'District 7, represented by Collin Peterson',  value: '7')
      Choice.create(question: congressional_question, order: 8, title: 'District 8, represented by Rick Nolan',       value: '8')
  vision_section = QuestionnaireSection.create(questionnaire: initial_board_questionnaire, order: 2, title: 'Vision')
    Question.create(questionnaire_section: vision_section, order: 1, text: 'What is your vision for Our Revolution MN and its affiliates?', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: vision_section, order: 2, text: 'What are your top three priorities, once elected?', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: vision_section, order: 3, text: 'My stance on effective statewide organizing is...', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: vision_section, order: 4, text: 'My stance on rural/urban candidate needs is...', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: vision_section, order: 5, text: 'My stance on how best to support progressive candidates is...', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: vision_section, order: 6, text: 'My stance on stewarding Our Revolution MN resources (such as its people and the people\'s money) is...', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: vision_section, order: 7, text: 'My stance on coordination/cooperation with political parties is...', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: vision_section, order: 8, text: 'My stance on how to mediate intra-organizational conflict is...', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: vision_section, order: 9, text: 'If Senator Bernie Sanders came to our meeting, I would tell him...', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: vision_section, order: 10, text: 'If I could start Our Revolution MN from scratch, I would...', question_type: Question::QUESTION_TYPE_LONG_TEXT)
  leadership_section = QuestionnaireSection.create(questionnaire: initial_board_questionnaire, order: 3, title: 'Leadership Qualifications')
    Question.create(questionnaire_section: leadership_section, order: 1, text: 'Describe your experiences, talents, and skill sets that will help you be effective on the Board of Our Revolution MN', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    experiences_question = Question.create(questionnaire_section: leadership_section, order: 2, text: 'Select all that apply', question_type: Question::QUESTION_TYPE_CHECKBOXES)
      Choice.create(question: experiences_question, order: 1, title: 'Have been elected to an official position',                                     value: 'elected-to-official-position')
      Choice.create(question: experiences_question, order: 2, title: 'Held public office position',                                                   value: 'held-public-office')
      Choice.create(question: experiences_question, order: 3, title: 'Currently hold an elected or public office position',                           value: 'hold-public-office')
      Choice.create(question: experiences_question, order: 4, title: 'Have run for office',                                                           value: 'have-run-for-office')
      Choice.create(question: experiences_question, order: 5, title: 'Currently volunteer for 1 or more organizations other than Our Revolution MN',  value: 'volunteer')
    work_question = Question.create(questionnaire_section: leadership_section, order: 3, text: 'On average, in an ordinary week, how much time can you commit to working on ORMN Board activities?', question_type: Question::QUESTION_TYPE_MULTIPLE_CHOICE)
      Choice.create(question: work_question, order: 1, title: '1-4 hours per week',     value: '1-4')
      Choice.create(question: work_question, order: 2, title: '5-9 hours per week',     value: '5-9')
      Choice.create(question: work_question, order: 3, title: '10-13 hours per week',   value: '10-13')
      Choice.create(question: work_question, order: 4, title: 'I am willing to spend whatever time it takes per week, as needed', value: 'as-needed')
      Choice.create(question: work_question, order: 5, title: 'Other',                  value: 'other')
    Question.create(questionnaire_section: leadership_section, order: 4, text: 'How will you use your candidacy/elected position on the board to engage more citizens in the political process?', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: leadership_section, order: 5, text: 'How will you identify and recruit new progressive candidates to run for public office in Minnesota, particularly in rural Minnesota?', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: leadership_section, order: 6, text: 'What is your plan to raise money for operations at Our Revolution MN?', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: leadership_section, order: 7, text: 'Why is holding a position on the Board of Our Revolution MN important to you? What\'s in it for you? ', question_type: Question::QUESTION_TYPE_LONG_TEXT)
    Question.create(questionnaire_section: leadership_section, order: 8, text: 'Is there anything else you would like the Our Revolution MN members to know about you?', question_type: Question::QUESTION_TYPE_LONG_TEXT)
# end

