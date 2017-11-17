require 'rails_helper'

describe RacePolicy do
  describe "show_candidacies?" do
    let(:external_election)               { create(:election, :external) }
    let(:internal_election)               { create(:election, :internal, vote_date: Date.new(2017, 9, 10)) }
    let(:external_race)                   { create(:race, election: external_election)}
    let(:internal_race)                   { create(:race, election: internal_election, candidates_announcement_date:  Date.new(2017,9,9))}

    let(:can_see_internal_candidates_privilege)   { create(:privilege, action: 'view_internal', subject: 'candidacy') }
    let(:privileged_role)                         { create(:role, privileges: [can_see_internal_candidates_privilege]) }
    let(:user)                                    { create(:user) }
    let(:privileged_user)                         { create(:user, role: privileged_role)}

    it " before the announcement date" do
      Timecop.freeze(2017,9,8)
      expect(RacePolicy.new(user, internal_race).show_candidacies?).to be_falsy
    end

    it "includes internal and external candidates on the announcement date" do
      Timecop.freeze(2017,9,9)
      expect(RacePolicy.new(user, internal_race).show_candidacies?).to be_truthy
    end

    it "includes internal and external candidates after the announcement date" do
      Timecop.freeze(2017,9,10)
      expect(RacePolicy.new(user, internal_race).show_candidacies?).to be_truthy
    end

    it "includes internal and external candidates before the announcement date" do
      Timecop.freeze(2017,9,8)
      expect(RacePolicy.new(privileged_user, internal_race).show_candidacies?).to be_truthy
    end

    it "includes internal and external candidates on or after the announcement date" do
      Timecop.freeze(2017,9,9)
      expect(RacePolicy.new(privileged_user, internal_race).show_candidacies?).to be_truthy
    end
  end
end