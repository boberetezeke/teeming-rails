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
end
