require 'rails_helper'

describe MessagesController do
  include Devise::Test::ControllerHelpers

  let(:messages_sender_role)  { FactoryBot.create(:role, privileges: [FactoryBot.create(:privilege, subject: 'message', action: 'send')]) }
  let(:user)                  { FactoryBot.create(:user) }
  let(:message_sender_user)   { FactoryBot.create(:user, role: messages_sender_role) }
  let(:chapter)               { FactoryBot.create(:chapter) }
  # let(:chapter_member_group)  { FactoryBot.create(:member_group, :chapter, members: []) }
  let(:message)               { FactoryBot.create(:message, chapter: chapter, member_group: MemberGroup.first) }
  let(:sent_message)          { FactoryBot.create(:message, sent_at: Time.now, chapter: chapter, member_group: MemberGroup.first) }

  before do
    MemberGroup.write_member_groups
    message.update(member_group_id: MemberGroup.first.id)
  end

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
      it "renders sent chapter messages when accessing this endpoint as a normal user" do
        get :index, params: { chapter_id: chapter.id }
        expect(response).to be_ok
        expect(assigns(:messages)).to eq([sent_message])
      end
    end

    describe "show" do
      it "doesn't allow users to view unsent messages" do
        get :show, params: { id: message.id, chapter_id: chapter.id }
        expect(response).to redirect_to(root_path)
      end

      it "allows users to view sent messages" do
        get :show, params: { id: sent_message.id, chapter_id: chapter.id }
        expect(response).to be_ok
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
        put :create, params: { message: { subject: 'subject', body: 'body', member_group_id: MemberGroup.first.id }  }
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
        expect(assigns(:messages)).to match_array([message, sent_message])
      end
    end

    describe "show" do
      it "shows the message" do
        get :show, params: { id: message.id, chapter_id: chapter.id }
        expect(response).to be_ok
      end
    end

    describe "new" do
      it "shows new page" do
        get :new, params: { chapter_id: chapter.id }
        expect(response).to be_ok
      end
    end

    describe "create" do
      it "redirects to the message show view" do
        put :create, params: { message: { subject: 'created subject', body: 'body', member_group_id: MemberGroup.first.id }  }
        message = Message.find_by_subject('created subject')
        expect(response).to redirect_to(message)
      end
    end

    describe "edit" do
      it "shows the edit form" do
        get :edit, params: { id: message.id, chapter_id: chapter.id }
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
