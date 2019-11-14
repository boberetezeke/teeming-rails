require "rails_helper"

describe ChapterBoundaries do
  it "detects above and east of boundaries" do
    expect(ChapterBoundaries.new([
     ChapterBoundary.new(ChapterBoundary::EAST_OF, x: 3),
     ChapterBoundary.new(ChapterBoundary::NORTH_OF, x1: 0, y1: 0, x2: 5, y2: 0)
    ]).within_boundaries?(4,1)).to be_truthy
  end

  it "detects not above and east of boundaries" do
    expect(ChapterBoundaries.new([
      ChapterBoundary.new(ChapterBoundary::EAST_OF, x: 3),
      ChapterBoundary.new(ChapterBoundary::NORTH_OF, x1: 0, y1: 0, x2: 5, y2: 0)
    ]).within_boundaries?(2,-1)).to be_falsy
  end
end