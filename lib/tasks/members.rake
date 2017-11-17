namespace :members  do
  desc "copy member emails from user's"
  task :copy_emails_from_user => :environment do
    Member.find_each do |member|
      member.update(email: member.user.email)
    end
  end
end
