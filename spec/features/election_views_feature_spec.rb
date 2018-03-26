require 'rails_helper'
include Warden::Test::Helpers
require 'capybara-screenshot/rspec'
require 'support/authentication'


context "when testing with a normal user" do
  let(:chapter) { Chapter.find_by_name("Duluth") }
  let(:other_chapter) { Chapter.find_by_name("Alexandria") }

  before do
    Rails.application.load_seed # loading seeds
    user.update(setup_state: nil)
    sign_in user
  end

  describe "election show" do
    context "with an ordinary user" do

    end
  end
end


