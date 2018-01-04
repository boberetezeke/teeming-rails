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
      if user_answers.present?
        user.member.answers.destroy_all
        user_answers.each do |answer|
          answer.update(answerable_type: "Member", answerable_id: user.member.id)
        end
      end
    end
  end
end
