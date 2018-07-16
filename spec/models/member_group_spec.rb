require 'rails_helper'

describe MemberGroup do
  let!(:chapter_state)  { FactoryBot.create(:chapter, name: 'chapter', is_state_wide: true)}
  let!(:chapter)        { FactoryBot.create(:chapter, name: 'chapter')}
  let!(:other_chapter)  { FactoryBot.create(:chapter, name: 'other chapter')}
  let!(:member_state_p) { FactoryBot.create(:member, email: 'member@c.com', chapter: chapter_state, potential_chapter_id: chapter.id) }
  let!(:member_state)   { FactoryBot.create(:member, email: 'member@d.com', chapter: chapter_state) }
  let!(:member)         { FactoryBot.create(:member, email: 'member@a.com', chapter: chapter) }
  let!(:member_other)   { FactoryBot.create(:member, email: 'member@b.com', chapter: other_chapter) }
  let!(:user)           { FactoryBot.create(:user,   email: 'user@a.com', chapter: chapter) }
  let!(:user_other)     { FactoryBot.create(:user,   email: 'user@b.com', chapter: other_chapter) }
  let!(:user_officer)   { FactoryBot.create(:user, email: 'officer@a.com', chapter: chapter) }
  let!(:officer)        { FactoryBot.create(:officer, users: [user_officer], chapter: chapter, start_date: 15.days.ago.to_date, end_date: 15.days.from_now.to_date) }
  let!(:user_officer_out_of_date)   { FactoryBot.create(:user, email: 'officer@aood.com', chapter: chapter) }
  let!(:officer_out_of_date)        { FactoryBot.create(:officer, users: [user_officer_out_of_date], chapter: chapter, start_date: Date.new(2017,1,1), end_date: Date.new(2017, 12, 31)) }
  let!(:user_board_member)        { FactoryBot.create(:user, email: 'board_member@a.com', chapter: chapter) }
  let!(:officer_board_member)     { FactoryBot.create(:officer, users: [user_board_member], is_board_member: true, chapter: chapter) }
  let!(:user_exec_cmmt_member)    { FactoryBot.create(:user, email: 'exec_cmmt_member@a.com', chapter: chapter) }
  let!(:officer_exec_cmmt_member) { FactoryBot.create(:officer, users: [user_exec_cmmt_member], is_executive_committee_member: true, is_board_member: true, chapter: chapter) }
  let!(:user_exec_cmmt_member_other)    { FactoryBot.create(:user, email: 'exec_cmmt_member@b.com', chapter: other_chapter) }
  let!(:officer_exec_cmmt_member_other) { FactoryBot.create(:officer, users: [user_exec_cmmt_member_other], is_executive_committee_member: true, is_board_member: true, chapter: other_chapter) }

  describe "#all_members" do
    context "when selecting chapter members" do
      let(:member_group) { MemberGroup.new(scope_type: :chapter_members, group_type: MemberGroup::GROUP_TYPE_SCOPE) }
      it "selects chapter members" do
        expect(member_group.all_members(chapter)).to match_array([member, user.member, user_officer.member, user_officer_out_of_date.member, user_board_member.member, user_exec_cmmt_member.member])
      end

      it "selects other chapter members" do
        mg = MemberGroup.new(scope_type: :chapter_members, group_type: MemberGroup::GROUP_TYPE_SCOPE)
        expect(member_group.all_members(other_chapter)).to match_array([member_other, user_other.member, user_exec_cmmt_member_other.member])
      end
    end

    context "when selecting potential chapter members" do
      let(:member_group) { MemberGroup.new(scope_type: :potential_chapter_members, group_type: MemberGroup::GROUP_TYPE_SCOPE) }
      it "selects correct members" do
        expect(member_group.all_members(chapter)).to match_array([member_state_p])
      end
    end

    context "when selecting officers" do
      let(:member_group) { MemberGroup.new(scope_type: :officers, group_type: MemberGroup::GROUP_TYPE_SCOPE) }
      it "selects chapter members" do
        expect(member_group.all_members(chapter)).to match_array([user_officer.member, user_board_member.member, user_exec_cmmt_member.member])
      end
    end

    context "when selecting board members" do
      let(:member_group) { MemberGroup.new(scope_type: :board_members, group_type: MemberGroup::GROUP_TYPE_SCOPE) }
      it "selects chapter members" do
        expect(member_group.all_members(chapter)).to match_array([user_board_member.member, user_exec_cmmt_member.member])
      end
    end

    context "when selecting executive committee members" do
      let(:member_group) { MemberGroup.new(scope_type: :executive_committee_members, group_type: MemberGroup::GROUP_TYPE_SCOPE) }
      it "selects chapter members" do
        expect(member_group.all_members(chapter)).to match_array([user_exec_cmmt_member.member])
      end
    end
  end
end
