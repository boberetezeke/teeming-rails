require 'rails_helper'

describe CandidacyPolicy do
  describe CandidacyPolicy::Scope do
    let(:external_election)               { create(:election, :external) }
    let(:internal_election)               { create(:election, :internal, vote_date: Date.new(2017,9,10)) }
    let(:external_race)                   { create(:race, election: external_election)}
    let(:internal_race)                   { create(:race, election: internal_election, candidates_announcement_date:  Date.new(2017,9,9))}
    let!(:internal_candidacy)             { create(:candidacy, race: internal_race)}
    let!(:external_candidacy)             { create(:candidacy, race: external_race)}

    let(:can_see_internal_candidates_privilege)   { create(:privilege, action: 'manage_internal', subject: 'election') }
    let(:privileged_role)                         { create(:role, privileges: [can_see_internal_candidates_privilege]) }
    let(:user)                                    { create(:user) }
    let(:privileged_user)                         { create(:user, role: privileged_role)}

    context "when the user has no privilege to see internal races" do
      context "when its before the announcement date" do
        it "includes only the external candidates before the announcement date" do
          Timecop.freeze(2017,9,8)
          expect(CandidacyPolicy::Scope.new(user, Candidacy).resolve).to match_array([external_candidacy])
        end

        it "includes internal and external candidates on the announcement date" do
          Timecop.freeze(2017,9,9)
          expect(CandidacyPolicy::Scope.new(user, Candidacy).resolve).to match_array([internal_candidacy, external_candidacy])
        end

        it "includes internal and external candidates after the announcement date" do
          Timecop.freeze(2017,9,10)
          expect(CandidacyPolicy::Scope.new(user, Candidacy).resolve).to match_array([internal_candidacy, external_candidacy])
        end
      end
    end

    context "when the user has privileges to see internal races" do
      context "when its at or after the announcement date" do
        it "includes internal and external candidates before the announcement date" do
          Timecop.freeze(2017,9,8)
          expect(CandidacyPolicy::Scope.new(privileged_user, Candidacy).resolve).to match_array([internal_candidacy, external_candidacy])
        end

        it "includes internal and external candidates on or after the announcement date" do
          Timecop.freeze(2017,9,9)
          expect(CandidacyPolicy::Scope.new(privileged_user, Candidacy).resolve).to match_array([internal_candidacy, external_candidacy])
        end
      end
    end
  end
end