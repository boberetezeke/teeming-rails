namespace :elections  do
  desc "Copy the vote times from races to elections"
  task :copy_race_vote_times => :environment do
    Election.internal.each do |election|
      election.races.each do |race|
        election.vote_start_time = race.vote_start_time
        election.vote_end_time = race.vote_end_time
        election.save
      end
    end
  end
end