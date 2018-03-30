require 'rails_helper'
include Warden::Test::Helpers
require 'capybara-screenshot/rspec'
require 'support/authentication'


context "when testing with a normal user" do
  let(:chapter)             { Chapter.find_by_name("Duluth") }
  let(:other_chapter)       { Chapter.find_by_name("Alexandria") }

  before do
    Rails.application.load_seed # loading seeds
    user.update(setup_state: nil)
    sign_in user
  end

  context "when testing external elections" do
    let(:user)       { FactoryBot.create(:user) }
    let(:election)   { FactoryBot.create(:election, :external) }
    let!(:race_1)     { FactoryBot.create(:race, locale: 'Roseville', election: election) }
    let!(:race_2)     { FactoryBot.create(:race, locale: 'Edina', election: election) }

    describe "election show" do
      it "shows the races" do
        visit election_races_path(election)
        expect(page).to have_text "Roseville"
        expect(page).to have_text "Edina"
      end
    end
  end

  context "when testing internal elections" do
    let(:user)          { FactoryBot.create(:user) }
    let(:election)      { FactoryBot.create(:election, :internal, chapter: chapter,
                                             member_group: MemberGroup.find_by_name('Officers'),
                                             vote_date: Date.new(2022,1,1),
                                             vote_start_time: Time.new(2022,1,1,10,00),
                                             vote_end_time: Time.new(2022,1,1,11,00)) }

    describe "election show" do
      context "with an ordinary user" do
        it "doesn't allow a visit to the show page" do
          visit election_path(election)
          expect(page).to have_text "User does not have permission to access this page"
          expect(page).to have_current_path(root_path)
        end
      end

      context "with a user who is part of the voting pool" do
        it "allows a visit to the show page" do
          FactoryBot.create(:vote_completion, user: user, election: election)
          visit election_path(election)
          expect(page).to have_current_path(election_path(election))
          expect(page).to have_selector "a[href='#{election_votes_path(election)}']"
          expect(page).to have_text "Wait to Vote"
          expect(page).to_not have_text "Edit"
          # expect(page).to_not have_text "Add Race"
          expect(page).to_not have_text "Add Issue"
          expect(page).to_not have_text "Freeze"
          expect(page).to_not have_text "UnFreeze"
          expect(page).to_not have_text "View Questionnaire"
          expect(page).to_not have_text "Email Participants"
          expect(page).to_not have_text "Delete"

          expect(page).to_not have_text "View Your Vote"
        end

        it "allows the user to vote when voting time active" do
          FactoryBot.create(:vote_completion, user: user, election: election, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_ONLINE )
          Timecop.freeze(2022,1,1,10,01)
          visit election_path(election)
          expect(page).to have_text "Vote"
          expect(page).to have_selector "a[href='#{election_votes_path(election)}']"

          expect(page).to_not have_text "View Vote Tallies"
          expect(page).to_not have_text "View Raw Votes"
          expect(page).to_not have_text "Download Votes"
        end

        it "doesn't allows the user to view their vote after voting is done and they haven't voted" do
          FactoryBot.create(:vote_completion, user: user, election: election, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_ONLINE )
          Timecop.freeze(2022,1,1,11,01)
          visit election_path(election)
          expect(page).to_not have_text "View Your Vote"
          expect(page).to_not have_selector "a[href='#{view_election_votes_path(election)}']"

          expect(page).to_not have_text "View Vote Tallies"
          expect(page).to_not have_text "View Raw Votes"
          expect(page).to_not have_text "Download Votes"
        end

        it "allows the user to view their vote after voting is done" do
          FactoryBot.create(:vote_completion, user: user, election: election, has_voted: true, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_ONLINE )
          Timecop.freeze(2022,1,1,11,01)
          visit election_path(election)
          expect(page).to have_text "View Your Vote"
          expect(page).to have_selector "a[href='#{view_election_votes_path(election)}']"
        end
      end

      context "with a user who can manage internal elections" do
        before do
          user.update(role: FactoryBot.create(:role, privileges: [FactoryBot.create(:privilege, subject: 'election', action: 'manage_internal')]))
        end

        it "allows a visit to the show page with an unfrozen election" do
          visit election_path(election)
          expect(page).to have_current_path(election_path(election))

          expect(page).to have_text "Edit"
          expect(page).to have_selector "a[href='#{edit_election_path(election)}']"
          # expect(page).to have_text "Add Race"
          # expect(page).to have_selector "a[href='#{new_election_race_path(election, chapter_id: chapter.id)}']"
          expect(page).to have_text "Add Issue"
          expect(page).to have_selector "a[href='#{new_election_issue_path(election, chapter_id: chapter.id)}']"
          expect(page).to have_text "Freeze"
          expect(page).to have_selector "a[href='#{freeze_election_path(election)}']"
          expect(page).to have_text "Delete"
          expect(page).to have_selector "a[href='#{election_path(election, chapter_id: chapter.id)}']"
        end

        it "allows a visit to the show page with an frozen election" do
          election.issues << FactoryBot.create(:issue, election: election, chapter: chapter)
          election.freeze_election
          visit election_path(election)
          expect(page).to have_current_path(election_path(election))

          expect(page).to have_text "Unfreeze"
          expect(page).to have_selector "a[href='#{unfreeze_election_path(election)}']"
          expect(page).to have_text "View Questionnaire"
          expect(page).to have_selector "a[href='#{questionnaire_path(election.questionnaire)}']"
          expect(page).to have_text "Email Participants"
          expect(page).to have_selector "a[href='#{email_election_path(election)}']"
          expect(page).to have_text "Delete"
          expect(page).to have_selector "a[href='#{election_path(election, chapter_id: chapter.id)}']"
        end
      end
    end
  end
end


