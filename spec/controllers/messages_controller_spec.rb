require 'rails_helper'

describe MessagesController do
  include Devise::Test::ControllerHelpers

  let(:messages_sender_role)  { FactoryGirl.create(:role, privileges: [FactoryGirl.create(:privilege, subject: 'message', action: 'send')]) }
  let(:user)                  { FactoryGirl.create(:user) }
  let(:message_sender_user)   { FactoryGirl.create(:user, role: messages_sender_role) }
  let(:chapter)               { FactoryGirl.create(:chapter) }
  let(:chapter_member_group)  { FactoryGirl.create(:member_group, :chapter, members: []) }
  let(:message)               { FactoryGirl.create(:message) }

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

    describe "show" do
      it "redirects to root path when accessing this endpoint" do
        get :show, params: { id: message.id }
        expect(response).to redirect_to(root_path)
      end
    end

    describe "new" do
      it "redirects to root path when accessing this endpoint" do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    describe "create" do
      it "redirects to root path when accessing this endpoint" do
        put :create, params: { message: { subject: 'subject', body: 'body', member_group_id: chapter_member_group.id }  }
        expect(response).to redirect_to(root_path)
      end
    end

    describe "edit" do
      it "redirects to root path when accessing this endpoint" do
        get :edit, params: { id: message.id }
        expect(response).to redirect_to(root_path)
      end
    end

    describe "update" do
      it "redirects to root path when accessing this endpoint" do
        put :update, params: {  id: message.id, message: { subject: 'new subject' } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context "when user is signed in with member view privileges" do
    before do
      sign_in message_sender_user
    end

    describe "index" do
      it "renders the index view" do
        get :index, params: { chapter_id: chapter.id }
        expect(response).to be_ok
      end
    end

    describe "show" do
      it "shows the message" do
        get :show, params: { id: message.id }
        expect(response).to be_ok
      end
    end

    describe "new" do
      it "shows new page" do
        get :new
        expect(response).to be_ok
      end
    end

    describe "create" do
      it "redirects to the message show view" do
        put :create, params: { message: { subject: 'created subject', body: 'body', member_group_id: chapter_member_group.id }  }
        message = Message.find_by_subject('created subject')
        expect(response).to redirect_to(message)
      end
    end

    describe "edit" do
      it "shows the edit form" do
        get :edit, params: { id: message.id }
        expect(response).to be_ok
      end
    end

    describe "update" do
      it "redirects to message show view" do
        put :update, params: {  id: message.id, message: { subject: 'new subject' } }
        expect(response).to redirect_to(message)
      end
    end
  end
end
