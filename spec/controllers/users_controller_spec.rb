require 'rails_helper'

describe UsersController do
  include Devise::Test::ControllerHelpers

  describe "home" do
    before do
      Rails.application.load_seed # loading seeds
      sign_in FactoryGirl.create(:user)
    end

    it "should display the dashboard" do
      get :home
      expect(response).to be_ok
    end
  end

  describe "update" do
    let(:event)                             { FactoryGirl.create(:event) }
    let(:event_rsvps_attributes_no_rsvp)    { { event_rsvps_attributes: { "0" => {event_id: 1} } } }
    let(:event_rsvps_attributes_in_person)  { { event_rsvps_attributes: { "0" => {event_id: 1, rsvp_type: "in-person"} } } }

    let(:question)                { FactoryGirl.create(:question) }
    let(:candidacy_attributes)    do
      {
        candidacies_attributes: {
            "0" => {
                race_id: race.id,
                user_id: user.id,
                answers_attributes: {
                    "0" => {
                        question_id: question.id,
                        text: 'answer'
                    }
                }
            }
        }
      }
    end
    let(:user)   { FactoryGirl.create(:user) }

    before do
      Rails.application.load_seed # loading seeds
      sign_in FactoryGirl.create(:user)
    end

    it "allows signup before the candidacy filing date is up" do
      race = Race.first.update(filing_deadline_date: Date.new(2017,3,10))
      user.update(setup_state: 'step_declare_candidacy')
      Timecop.freeze(Time.zone.local(2017,3,10,23,59,59))

      put :update, params: {id: user.id, user: { run_for_state_board: "1" }.merge(event_rsvps_attributes_in_person)}

      expect(user.reload.setup_state).to eq("")
      expect(flash[:alert]).to be_nil
    end

    it "disallows signup after the candidacy filing date is up" do
      race = Race.first.update(filing_deadline_date: Date.new(2017,3,10))
      user.update(setup_state: 'step_declare_candidacy')
      Timecop.freeze(Time.zone.local(2017,3,11,00,00,00))

      put :update, params: {id: user.id, user: { run_for_state_board: "1" }.merge(event_rsvps_attributes_in_person)}

      expect(user.reload.setup_state).to eq('step_declare_candidacy')
      expect(flash[:alert]).to eq('the filing deadline is past')
    end
  end
end