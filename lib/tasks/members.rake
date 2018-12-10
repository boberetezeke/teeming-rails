namespace :members  do
  desc "copy member emails from user's"
  task :copy_emails_from_user => :environment do
    Member.find_each do |member|
      member.update(email: member.user.email)
    end
  end

  desc "move user answers to member answers"
  task :move_user_answers_to_members => :environment do
    User.find_each do |user|
      user_answers = user.answers.where(answerable_type: nil)
      puts "user email = #{user.email}"
      if user_answers.present?
        user.member.answers.destroy_all
        user_answers.each do |answer|
          if answer.question.question_type == Question::QUESTION_TYPE_CHECKBOXES
            answer.text = answer.text.gsub(/ /, ":::") if answer.text
            puts "  updating check box answer = #{answer.id}: #{answer.text}"
          else
            puts "  updating non check box answer: #{answer.id}"
          end
          answer.answerable_type = "Member"
          answer.answerable_id = user.member.id
          answer.save
        end
      end
    end
  end

  desc "add message controls for users and email"
  task :add_message_controls_for_users => :environment do
    User.find_each do |user|
      if user.member.message_controls.empty?
        puts "adding member controls for #{user.email}"
        user.member.message_controls << MessageControl.new(unsubscribe_type: MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL, control_type: MessageControl::CONTROL_TYPE_NEUTRAL)
      end
    end
  end

  desc "add unsubscribes for database2.csv from unsubscribes from send grid"
  task :add_unsubscribes do
    suppressions = Hash[CSV.read("members/unsubscribes/asm_groups_3893_suppressions.csv").map{|row| [row[0], true]}]
    spam_reports = Hash[CSV.read("members/unsubscribes/suppression_spam_reports.csv").map{|row| [row[1], true]}]
    unsubscribes = Hash[CSV.read("members/unsubscribes/suppression_unsubscribes.csv").map{|row| [row[0], true]}]

    all_unsubscribes = suppressions.merge(spam_reports.merge(unsubscribes))
    with_unsubscribes = CSV.open("members/databank3.csv", "wb")

    index = 0
    CSV.foreach("members/databank2.csv") do |row|
      if index == 0
        with_unsubscribes << row + ['unsubscribe']
      else
        email = row[6]
        with_unsubscribes << row + [all_unsubscribes[email] ? "true": "false"]
      end

      index += 1
    end

    with_unsubscribes.close
  end

  desc "remove non-user members"
  task :remove_non_user_members => :environment do
    Member.where(user_id: nil).destroy_all
  end


  desc "merge contacts"
  task :merge_contacts, [:curl_address] => :environment do |t, args|
    if args[:curl_address].present?
      system("curl #{args[:curl_address]} >/tmp/merge.csv")
      contacts_str = File.read("/tmp/merge.csv")
      ImportCds.import_contacts_csv(contacts_str)
    else
      puts "curl_address argument missing"
    end
  end

  desc "geocode members"
  task :geocode => :environment do
    Member.where("lower(state) = 'mn'").find_each do |member|
      Geocoding.update_lat_lon_for_member(member)

      puts "updating #{member.email} - city:#{member.city} - latitude: #{member.latitude} - longitude: #{member.longitude}"

      member.save if member.changed?
    end
  end

  desc "set chapter boundaries YAML"
  task :set_chapter_boundaries_yml, [:chapter_boundaries_yml_file] => :environment do |t, args|
    yml = YAML.load(File.open(args[:chapter_boundaries_yml_file]))
    chapter_hash = Chapter.all.map{|c| [c.name.downcase.strip, c.id]}.to_h

    yml.each do |chapter_and_boundaries|
      puts "chapter_and_boundaries: #{chapter_and_boundaries}"
      chapter_name = chapter_and_boundaries[:name]
      if chapter_hash[chapter_name.downcase.strip].nil?
        puts "Chapter not found: #{chapter_name}"
        exit
      end
    end

    yml.each do |chapter_and_boundaries|
      chapter_name = chapter_and_boundaries[:name].downcase.strip
      chapter = Chapter.find(chapter_hash[chapter_name])
      chapter.boundaries_description_yml = chapter_and_boundaries[:boundaries].to_yaml
      chapter.save
    end
  end

  desc "set potential chapter id"
  task :set_potential_chapter => :environment do |t, args|
    state_chapter = Chapter.find_by(is_state_wide: true)
    member = Member.arel_table
    members_to_check = Member.where(
      member[:chapter_id].eq(state_chapter.id).or(member[:chapter_id].eq(nil)).and(
          member[:latitude].not_eq(nil).and(member[:longitude].not_eq(nil))
      ))
    chapters = Chapter.all.reject(&:is_state_wide)
    cities_to_chapter = {}
    chapters.each{|c| c.cities.each{|city| cities_to_chapter[city] = c}}

    potential_chapter_ids_set = 0
    members_to_check.find_each do |member|
      if member.city.present?
        city = Geocoding.clean_city(member.city)
        chapter = cities_to_chapter[city]
        if chapter
          puts "for #{member.first_name} #{member.last_name} in #{member.city} setting chapter to #{chapter.name}"
          member.potential_chapter_id = chapter.id
          member.save
          potential_chapter_ids_set += 1
        end
      end
    end

    puts "Members to check #{members_to_check.size}"
    puts "Updated #{potential_chapter_ids_set} potential chapter ids"
  end
end
