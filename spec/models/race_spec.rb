require 'rails_helper'

describe Race do
  describe "#candidates_announced?" do
    let(:candidacy)   { FactoryGirl.create(:candidacy) }
    let(:race)         { FactoryGirl.create(:race, candidacies: [candidacy])}

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
end