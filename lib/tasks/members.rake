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
end
