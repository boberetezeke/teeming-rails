require 'rails_helper'

describe User do
  describe "update_role_from_roles" do
    context "when the user has no role" do
      let(:user) { FactoryGirl.create(:user, role: nil) }

      it "creates a role with identical privileges to one entry in roles" do
        user.roles = [Role.new(name: 'role', privileges: [Privilege.new(action: 'action', subject: 'subject')])]
        user.save
        user.update_role_from_roles

        expect(user.role.privileges.count).to eq(1)
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