require 'rails_helper'

describe Race do
  describe "#candidates_announced?" do
    let(:candidacy_1)   { FactoryGirl.create(:candidacy) }
    let(:candidacy_2)   { FactoryGirl.create(:candidacy) }
    let(:candidacy_3)   { FactoryGirl.create(:candidacy) }
    let(:race)          { FactoryGirl.create(:race, candidacies: [candidacy_1, candidacy_2, candidacy_3]) }

    it "says that no candidates announced if there is no annoucement date" do
      expect(race.candidates_announced?).to be_falsy
    end
  end

  describe "#before_filing_deadline?" do
    let(:race)         { FactoryGirl.create(:race, filing_deadline_date: Date.new(2017, 3, 10)) }

    it "is true 1 second before the filing deadline" do
      expect(race.before_filing_deadline?(Time.zone.local(2017,3,10,23,59,59).utc)).to be_truthy
    end

    it "is false on the first second of the filing deadline" do
      expect(race.before_filing_deadline?(Time.zone.local(2017,3,11,00,00,00).utc)).to be_falsy
    end
  end

  context "when tallying votes" do
    let(:candidacy_1)   { FactoryGirl.create(:candidacy) }
    let(:candidacy_2)   { FactoryGirl.create(:candidacy) }
    let(:candidacy_3)   { FactoryGirl.create(:candidacy) }
    let(:race)          { FactoryGirl.create(:race, candidacies: [candidacy_1, candidacy_2, candidacy_3]) }

    let(:user_1) { FactoryGirl.create(:user) }
    let(:user_2) { FactoryGirl.create(:user) }

    let!(:vote_1) { FactoryGirl.create(:vote, user: user_1, candidacy: candidacy_1, race: race) }
    let!(:vote_2) { FactoryGirl.create(:vote, user: user_2, candidacy: candidacy_1, race: race) }
    let!(:vote_3) { FactoryGirl.create(:vote, user: user_1, candidacy: candidacy_2, race: race) }

    describe "#tally_votes" do
      context "when there are votes only" do
        it "counts tallies correctly" do
          tallies = race.tally_votes
          expect(tallies[candidacy_1]).to eq(2)
          expect(tallies[candidacy_2]).to eq(1)
          expect(tallies[candidacy_3]).to be_nil
        end
      end

      context "when there are votes and vote tallies only" do
        let!(:vote_tally_1)   { FactoryGirl.create(:vote_tally, race: race, candidacy: candidacy_1, vote_count: 3) }
        let!(:vote_tally_3)   { FactoryGirl.create(:vote_tally, race: race, candidacy: candidacy_3, vote_count: 1) }

        it "counts votes based on vote tallies" do
          tallies = race.tally_votes
          expect(tallies[candidacy_1]).to eq(3)
          expect(tallies[candidacy_2]).to be_nil
          expect(tallies[candidacy_3]).to eq(1)
        end
      end
    end

    describe "#write_tallies" do
      it "writes tallies correctly" do
        race.write_tallies
        expect(VoteTally.count).to eq(2)

        candidacy_1_tallies = VoteTally.where(candidacy: candidacy_1)
        expect(candidacy_1_tallies.count).to eq(1)
        expect(candidacy_1_tallies.first.vote_count).to eq(2)

        candidacy_2_tallies = VoteTally.where(candidacy: candidacy_2)
        expect(candidacy_2_tallies.count).to eq(1)
        expect(candidacy_2_tallies.first.vote_count).to eq(1)

        candidacy_3_tallies = VoteTally.where(candidacy: candidacy_3)
        expect(candidacy_3_tallies.count).to eq(0)
      end
    end
  end
end