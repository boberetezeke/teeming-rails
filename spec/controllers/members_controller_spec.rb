require 'rails_helper'

describe MembersController do
  include Devise::Test::ControllerHelpers

  let(:member_viewer_role)  { FactoryGirl.create(:role, privileges: [FactoryGirl.create(:privilege, subject: 'member', action: 'view')]) }
  let(:user)                { FactoryGirl.create(:user) }
  let(:member_viewer_user)  { FactoryGirl.create(:user, role: member_viewer_role) }
  let(:chapter)             { FactoryGirl.create(:chapter) }

  context "when users is not signed in" do
    describe "index" do
      it "redirects to root path when accessing this endpoint" do
        get :index, params: { chapter_id: chapter.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "when user is signed in with no member privileges" do
    before do
      sign_in user
    end

    describe "index" do
      it "redirects to root path when accessing this endpoint" do
        get :index, params: { chapter_id: chapter.id }
        expect(response).to redirect_to(root_path)
      end
    end

  end

  context "when user is signed in with member view privileges" do
    before do
      sign_in member_viewer_user
    end

    describe "index" do
      it "renders the index view" do
        get :index, params: { chapter_id: chapter.id }
        expect(response).to be_ok
      end
    end
  end
end


