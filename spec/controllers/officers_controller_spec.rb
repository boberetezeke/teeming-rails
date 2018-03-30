require 'rails_helper'

describe OfficersController do
  include Devise::Test::ControllerHelpers

  let(:assign_role_role)    { FactoryBot.create(:role, privileges: [FactoryBot.create(:privilege, subject: 'role', action: 'assign')])}
  let(:user)                { FactoryBot.create(:user, roles: [assign_role_role]) }
  let(:chapter)             { FactoryBot.create(:chapter) }
  let(:other_chapter)       { FactoryBot.create(:chapter) }
  let(:officer)             { FactoryBot.create(:officer, chapter: chapter)}
  let(:role)                { FactoryBot.create(:role, privileges: [FactoryBot.create(:privilege, subject: 'message', action: 'send')]) }
  let(:officer_writer_role)               { FactoryBot.create(:role, privileges: [FactoryBot.create(:privilege, subject: 'officer', action: 'write', scope: {chapter_id: chapter.id}.to_json)])}
  let(:other_chapter_officer_writer_role) { FactoryBot.create(:role, privileges: [FactoryBot.create(:privilege, subject: 'officer', action: 'write', scope: {chapter_id: other_chapter.id}.to_json)])}

  let(:chapter_officer_writer_user)       { FactoryBot.create(:user, role: officer_writer_role, chapter: chapter) }
  let(:other_chapter_officer_writer_user) { FactoryBot.create(:user, role: other_chapter_officer_writer_role, chapter: other_chapter) }

  context "when users is not signed in" do
    describe "index" do
      it "redirects to root path when accessing this endpoint" do
        get :index, params: { chapter_id: chapter.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "when user is signed in" do
    before do
      sign_in user
    end

    describe "index" do
      it "renders the index view" do
        get :index, params: { chapter_id: chapter.id }
        expect(response).to be_ok
      end
    end

    describe "#new" do
      it "redirects to the root path when the user has no privileges" do
        get :new, params: { chapter_id: chapter.id }
        expect(response).to redirect_to(root_path)
      end

      it "redirects to the root path when the user has officer write privileges for a different chapter" do
        sign_in other_chapter_officer_writer_user
        get :new, params: { chapter_id: chapter.id }
        expect(response).to redirect_to(root_path)
      end

      it "renders the index view" do
        sign_in chapter_officer_writer_user
        get :new, params: { chapter_id: chapter.id }
        expect(response).to be_ok
      end
    end

    describe "#create" do
      it "redirects to the root path when the user has no privileges" do
        post :create, params: { chapter_id: chapter.id, officer: { officer_type: "Prez", role_ids: [role.id], user_ids: [user.id]} }
        expect(response).to redirect_to(root_path)
      end

      it "redirects to the root path when the user has officer write privileges for a different chapter" do
        sign_in other_chapter_officer_writer_user
        post :create, params: { chapter_id: chapter.id, officer: { officer_type: "Prez", role_ids: [role.id], user_ids: [user.id]} }
        expect(response).to redirect_to(root_path)
      end

      it "renders the index view" do
        sign_in chapter_officer_writer_user
        post :create, params: { chapter_id: chapter.id, officer: { officer_type: "Prez", role_ids: [role.id], user_ids: [user.id]} }
        officer = Officer.first
        expect(officer.officer_type).to eq("Prez")
        expect(officer.roles).to eq([role])
        expect(officer.users).to eq([user])

        user_privileges = officer.users.first.role.privileges
        expect(user_privileges.count).to eq(2)

        role_assign_privilege = user_privileges.where(subject: 'role', action: 'assign').first
        message_send_privilege = user_privileges.where(subject: 'message', action: 'send').first
        expect(role_assign_privilege).to_not be_nil
        expect(message_send_privilege).to_not be_nil
        expect(message_send_privilege.scope).to eq({chapter_id: chapter.id}.to_json)

        expect(response).to redirect_to(officer_path(officer))
      end
    end

    describe "#edit" do
      it "redirects to the root path when the user has no privileges" do
        get :edit, params: { id: officer, chapter_id: chapter.id }
        expect(response).to redirect_to(root_path)
      end

      it "redirects to the root path when the user has officer write privileges for a different chapter" do
        sign_in other_chapter_officer_writer_user
        get :edit, params: { id: officer, chapter_id: chapter.id }
        expect(response).to redirect_to(root_path)
      end

      it "renders the index view" do
        sign_in chapter_officer_writer_user
        get :edit, params: { id: officer, chapter_id: chapter.id }
        expect(response).to be_ok
      end
    end

    describe "#update" do
      it "redirects to the root path when the user has no privileges" do
        put :update, params: { id: officer, officer: {officer_type: "Prez", role_ids: [role.id], user_ids: [user.id]} }
        expect(response).to redirect_to(root_path)
      end

      it "redirects to the root path when the user has officer write privileges for a different chapter" do
        sign_in other_chapter_officer_writer_user
        put :update, params: { id: officer, officer: {officer_type: "Prez", role_ids: [role.id], user_ids: [user.id]} }
        expect(response).to redirect_to(root_path)
      end

      it "renders the index view" do
        sign_in chapter_officer_writer_user
        put :update, params: { id: officer, officer: {officer_type: "Prez", role_ids: [role.id], user_ids: [user.id]} }
        officer.reload
        expect(officer.officer_type).to eq("Prez")
        expect(officer.roles).to eq([role])
        expect(officer.users).to eq([user])

        user_privileges = officer.users.first.role.privileges
        expect(user_privileges.count).to eq(2)

        role_assign_privilege = user_privileges.where(subject: 'role', action: 'assign').first
        message_send_privilege = user_privileges.where(subject: 'message', action: 'send').first
        expect(role_assign_privilege).to_not be_nil
        expect(message_send_privilege).to_not be_nil
        expect(message_send_privilege.scope).to eq({chapter_id: chapter.id}.to_json)

        expect(response).to redirect_to(officer_path(officer))
      end
    end

    describe "#destroy" do
      it "redirects to the root path when the user has no privileges" do
        delete :destroy, params: { id: officer }
        expect(response).to redirect_to(root_path)
      end

      it "redirects to the root path when the user has officer write privileges for a different chapter" do
        sign_in other_chapter_officer_writer_user
        delete :destroy, params: { id: officer }
        expect(response).to redirect_to(root_path)
      end

      it "renders the index view" do
        sign_in chapter_officer_writer_user

        officer.roles = [role]
        officer.users = [user]
        user.update_role_from_roles

        user_privileges = user.role.privileges
        expect(user_privileges.count).to eq(2)

        delete :destroy, params: { id: officer }

        user_privileges = user.role.privileges
        expect(user_privileges.count).to eq(1)

        role_assign_privilege = user_privileges.where(subject: 'role', action: 'assign').first
        expect(role_assign_privilege).to_not be_nil

        expect(response).to redirect_to(chapter_officers_path(chapter))
      end
    end
  end
end

