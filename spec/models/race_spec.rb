require 'rails_helper'

describe Race do
  describe "#candidates_announced?" do
    let(:candidacy)   { FactoryGirl.create(:candidacy) }
    let(:race)         { FactoryGirl.create(:race, candidacies: [candidacy])}

    it "says that no candidates announced if there is no annoucement date" do
      expect(race.candidates_announced?).to be_falsy
    end
  end
end