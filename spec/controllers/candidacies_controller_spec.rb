require 'rails_helper'

describe CandidaciesController do
  include Devise::Test::ControllerHelpers

  let(:internal_election)   { FactoryBot.create(:election, :internal) }
  let(:race)                { FactoryBot.create(:race, election: internal_election, filing_deadline_date: Date.new(2017,3,10) ) }
  let(:user)                { FactoryBot.create(:user) }
  let!(:questionnaire)      { FactoryBot.create(:questionnaire, questionnairable: race, use_type: Questionnaire::USE_TYPE_CANDIDACY) }

  before do
    sign_in user
  end

  describe "new" do
    it "allows a new candidate form if before filing date" do
      Timecop.freeze(Time.zone.local(2017,3,10,23,59,59))
      get :new, params: { race_id: race.id }
      expect(response).to be_ok
    end

    it "disallows a new candidate form if after filing date" do
      Timecop.freeze(Time.zone.local(2017,3,11,00,00,00))
      get :new, params: { race_id: race.id }
      expect(response).to redirect_to(candidacies_path)
      expect(flash[:alert]).to eq('the filing deadline is past')
    end
  end

  describe "create" do
    it "allows a new candidate form if before filing date" do
      Timecop.freeze(Time.zone.local(2017,3,10,23,59,59))
      post :create, params: {candidacy: { race_id: race.id, user_id: user.id }}
      expect(response).to redirect_to(root_path)
    end

    it "disallows a new candidate form if after filing date" do
      Timecop.freeze(Time.zone.local(2017,3,11,00,00,00))
      post :create, params: {candidacy: { race_id: race.id, user_id: user.id }}
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('the filing deadline is past')
    end
  end
end
