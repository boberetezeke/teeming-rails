require 'rails_helper'

describe MessageControlsController do
  include Devise::Test::ControllerHelpers

  context "when users is not signed in" do
    let(:message_recipient) { FactoryBot.create(:message_recipient, member: member) }

    context "when the member doesn't have an associated user" do
      let(:member)           { FactoryBot.create(:member) }

      describe "show" do
        let!(:message_control)   { FactoryBot.create(:message_control, member: member) }

        it "redirects to root path when accessing this endpoint" do
          get :show, params: { id: message_recipient.token }
          expect(response).to be_ok
        end
      end

      describe "edit" do
        it "renders the edit view for emails" do
          get :edit, params: { id: message_recipient.token }
          expect(response).to be_ok
        end
      end

      describe "create" do
        it "redirects to message control show path" do
          put :create, params: { message_recipient_id: message_recipient.id, message_control: { member_id: member.id, unsubscribe_type: MessageControl::CONTROL_TYPE_UNSUBSCRIBE } }
          expect(response).to redirect_to(message_control_path(message_recipient.token))
        end
      end

      describe "update" do
        let!(:message_control)   { FactoryBot.create(:message_control, member: member) }

        it "redirects to message control show path" do
          put :update, params: { id: message_control.id, message_recipient_id: message_recipient.id, message_control: { unsubscribe_type: MessageControl::CONTROL_TYPE_UNSUBSCRIBE } }
          expect(response).to redirect_to(message_control_path(message_recipient.token))
        end
      end
    end

    context "when the member does have an associated user" do
      let(:user)             { FactoryBot.create(:user)}
      let(:member)           { FactoryBot.create(:member, user: user) }

      describe "show" do
        let!(:message_control)   { FactoryBot.create(:message_control, member: member) }

        it "redirects to root path when accessing this endpoint" do
          get :show, params: { id: message_recipient.token }
          expect(response).to be_ok
        end
      end

      describe "edit" do
        it "redirects to root path when accessing this endpoint" do
          get :edit, params: { id: message_recipient.token }
          expect(response).to be_ok
        end
      end

      describe "create" do
        it "redirects to root path when accessing this endpoint" do
          put :create, params: { message_recipient_id: message_recipient.id, message_control: { member_id: member.id, unsubscribe_type: MessageControl::CONTROL_TYPE_UNSUBSCRIBE } }
          expect(response).to redirect_to(message_control_path(message_recipient.token))
        end
      end

      describe "update" do
        let!(:message_control)   { FactoryBot.create(:message_control, member: member) }

        it "redirects to root path when accessing this endpoint" do
          put :update, params: { id: message_control.id, message_recipient_id: message_recipient.id, message_control: { unsubscribe_type: MessageControl::CONTROL_TYPE_UNSUBSCRIBE } }
          expect(response).to redirect_to(message_control_path(message_recipient.token))
        end
      end
    end
  end
end


