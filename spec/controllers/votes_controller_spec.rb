require 'rails_helper'

describe VotesController do
  include Devise::Test::ControllerHelpers

  let(:internal_election)   { FactoryGirl.create(:election, :internal) }
  let(:race)                { FactoryGirl.create(:race, election: internal_election, vote_start_time: Time.zone.local(2017, 3, 10, 16, 00), vote_end_time: Time.zone.local(2017, 3, 10, 16, 30) ) }
  let(:user)                { FactoryGirl.create(:user) }

  before do
    sign_in user
  end

  describe "vote" do
    it "redirects to disqualified if the user tries to vote" do
      VoteCompletion.create(user: user, race: race, has_voted: false, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_DISQUALIFIED)
      get :index, params: { race_id: race.id }
      expect(response).to redirect_to(disqualified_race_votes_path(race_id: race.id))
    end

    it "redirects to wait if the time is before the vote start" do
      Timecop.freeze(Time.zone.local(2017, 3, 10, 15, 59, 59))
      get :index, params: { race_id: race.id }
      expect(response).to redirect_to(wait_race_votes_path(race_id: race.id))
    end

    it "does not redirect if it is between vote start and end near the beginning" do
      Timecop.freeze(Time.zone.local(2017, 3, 10, 16, 00, 00))
      get :index, params: { race_id: race.id }
      expect(response).to be_ok
    end

    it "does not redirect if it is between vote start and end near the end" do
      Timecop.freeze(Time.zone.local(2017, 3, 10, 16, 29, 59))
      get :index, params: { race_id: race.id }
      expect(response).to be_ok
    end

    it "redirects to missed if the time is after the vote end and the user has not voted" do
      Timecop.freeze(Time.zone.local(2017, 3, 10, 16, 30, 00))
      get :index, params: { race_id: race.id }
      expect(response).to redirect_to(missed_race_votes_path(race_id: race.id))
    end

    it "redirects to view if the time is after the vote end and the user has voted" do
      Timecop.freeze(Time.zone.local(2017, 3, 10, 16, 30, 00))
      VoteCompletion.create(user: user, race: race, has_voted: true, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_ONLINE)
      get :index, params: { race_id: race.id }
      expect(response).to redirect_to(view_race_votes_path(race_id: race.id))
    end
  end

  describe "create" do
    it "redirects to disqualified if the user tries to vote" do
      VoteCompletion.create(user: user, race: race, has_voted: false, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_DISQUALIFIED)
      post :create, params: { race_id: race.id }
      expect(response).to redirect_to(disqualified_race_votes_path(race_id: race.id))
    end
  end

  describe "view" do
    it "redirects to disqualified if the user tries to vote" do
      VoteCompletion.create(user: user, race: race, has_voted: false, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_DISQUALIFIED)
      get :view, params: { race_id: race.id }
      expect(response).to redirect_to(disqualified_race_votes_path(race_id: race.id))
    end
  end
end
