require 'rails_helper'

describe User do
  describe "update_role_from_roles" do
    context "when the user has no role" do
      let(:chapter)       { FactoryGirl.create(:chapter) }
      let(:user)          { FactoryGirl.create(:user, role: nil, chapter: chapter) }
      let(:officer_role)  { FactoryGirl.create(:role, privileges: [FactoryGirl.create(:privilege, subject: 'officer_subject', action: 'officer_action')])}
      let(:officer)       { FactoryGirl.create(:officer, chapter: chapter, users: [user], roles: [officer_role])}

      it "creates a role with identical privileges to one entry in roles" do
        user.roles = [Role.new(name: 'role', privileges: [Privilege.new(action: 'action', subject: 'subject')])]
        user.save
        user.update_role_from_roles

        expect(user.role.privileges.count).to eq(1)
        privilege = user.role.privileges.first
        expect(privilege.subject).to eq('subject')
        expect(privilege.action).to eq('action')
        expect(user.role.combined).to be_truthy
      end


      it "creates a role with privileges combined from roles and officer roles" do
        officer
        user.roles = [Role.new(name: 'role', privileges: [Privilege.new(action: 'action', subject: 'subject')])]
        user.save
        user.update_role_from_roles

        expect(user.role.privileges.count).to eq(2)
        local_privilege = user.role.privileges.where(subject:'subject').first
        expect(local_privilege.action).to eq('action')
        officer_privilege = user.role.privileges.where(subject: 'officer_subject').first
        expect(officer_privilege.action).to eq('officer_action')
        expect(officer_privilege.scope).to eq({chapter_id: chapter.id}.to_json)
        expect(user.role.combined).to be_truthy
      end

      it "creates a role with identical privileges to two entry in roles with identical privileges" do
        user.roles = [Role.new(name: 'role', privileges: [
          Privilege.new(action: 'action', subject: 'subject'),
          Privilege.new(action: 'action', subject: 'subject')
        ])]
        user.save
        user.update_role_from_roles

        expect(user.role.privileges.count).to eq(1)
      end

      it "leave the role empty if roles is empty" do
        user.roles = []
        user.save
        user.update_role_from_roles

        expect(user.role).to be_nil
      end

      it "doesn't set role if there are no roles and the user had no role" do
        user.update_role_from_roles
        expect(user.role).to be_nil
      end
    end

    context "when the user has a role" do
      let(:user) { FactoryGirl.create(:user, role: Role.new(name: 'role', privileges: [Privilege.new(action: 'action', subject: 'subject')])) }

      it "creates a role with identical privileges to one entry in roles" do
        user.roles = [Role.new(name: 'role', privileges: [Privilege.new(action: 'action', subject: 'subject')])]
        user.save
        user.update_role_from_roles

        expect(user.role.privileges.count).to eq(1)
      end

      it "creates a role with identical privileges to two entry in roles with identical privileges" do
        user.roles << Role.new(name: 'role', privileges: [
            Privilege.new(action: 'action', subject: 'subject'),
            Privilege.new(action: 'action', subject: 'subject')
        ])
        user.save
        user.update_role_from_roles

        expect(user.role.privileges.count).to eq(1)
      end

      it "removes a role if roles is empty" do
        user.roles = []
        user.save
        user.update_role_from_roles

        expect(user.role).to be_nil
      end
    end
  end
end