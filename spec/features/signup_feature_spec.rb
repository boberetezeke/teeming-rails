require 'rails_helper'
include Warden::Test::Helpers
require 'capybara-screenshot/rspec'
require 'support/authentication'

describe "Signup process" do
  def fill_in_member_info
    fill_in "user_member_attributes_first_name", with: 'Fred'
    fill_in "user_member_attributes_last_name", with: 'Flintstone'
    fill_in "user_member_attributes_address_1", with: '308 Boulder Lane'
    fill_in "user_member_attributes_address_1", with: '308 Boulder Lane'
    fill_in "user_member_attributes_city", with: 'Rockburry'
    fill_in "user_member_attributes_state", with: 'MN'
    fill_in "user_member_attributes_zip", with: '55314'
  end

  context "when going through signup" do
    let(:user) { FactoryBot.create(:user) }

    before do
      user.member.update(added_with_new_user: true)
      Rails.application.load_seed # loading seeds
      sign_in user
      visit home_users_path
    end

    it "displays the member details form" do
      expect(page).to have_selector '#user_member_attributes_first_name'
    end

    it "loads the donate and volunteer information page", js: true do
      fill_in_member_info

      check("Accept bylaws and code of conduct")
      sleep(0.1)
      click_on("Next Step")

      expect(page).to have_selector("#user_interested_in_volunteering")
    end

    # it "loads the RSVP page", js: true do
    #   fill_in_member_info
    #   check("Accept bylaws and code of conduct")
    #   click_on("Next Step")
    #   click_on("Next Step")
    #
    #   expect(page).to have_selector("#user_event_rsvps_attributes_0_rsvp_type_input")
    # end

    it "loads the desktop page with a modal in front of it", js: true do
      fill_in_member_info
      check("Accept bylaws and code of conduct")
      click_on("Next Step")
      # click_on("Next Step")
      #choose "user_event_rsvps_attributes_0_rsvp_type_in-person"
      click_on("Done")

      expect(page).to have_selector("input[value=Ok]")
    end
  end
end

