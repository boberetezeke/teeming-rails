require 'rails_helper'

describe UsersController do
  describe "home" do
    it "should display the dashboard" do
      get home_users_path
      expect(response).to be_ok
    end
  end
end