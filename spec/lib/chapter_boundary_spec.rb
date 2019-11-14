require "rails_helper"

describe ChapterBoundary do
  it "detects not east of an x value" do
    expect(ChapterBoundary.new(ChapterBoundary::EAST_OF, x: 3).satisfies_test?(2, 0)).to be_falsy
  end

  it "detects east of an x value" do
    expect(ChapterBoundary.new(ChapterBoundary::EAST_OF, x: 3).satisfies_test?(4, 0)).to be_truthy
  end

  it "detects not east or equal of an x value" do
    expect(ChapterBoundary.new(ChapterBoundary::EAST_OF, x: 3).satisfies_test?(2, 0)).to be_falsy
  end

  it "detects east or equal of an x value" do
    expect(ChapterBoundary.new(ChapterBoundary::EAST_OF_OR_EQUAL, x: 3).satisfies_test?(3, 0)).to be_truthy
  end

  it "detects not west of an x value" do
    expect(ChapterBoundary.new(ChapterBoundary::WEST_OF, x: 3).satisfies_test?(4, 0)).to be_falsy
  end

  it "detects west of an x value" do
    expect(ChapterBoundary.new(ChapterBoundary::WEST_OF, x: 3).satisfies_test?(2, 0)).to be_truthy
  end

  it "detects not west or equal of an x value" do
    expect(ChapterBoundary.new(ChapterBoundary::WEST_OF, x: 3).satisfies_test?(4, 0)).to be_falsy
  end

  it "detects west or equal of an x value" do
    expect(ChapterBoundary.new(ChapterBoundary::WEST_OF_OR_EQUAL, x: 3).satisfies_test?(3, 0)).to be_truthy
  end

  it "detects north of a line" do
    expect(ChapterBoundary.new(ChapterBoundary::NORTH_OF, x1: 1, y1: 1, x2: 5, y2: 5 ).satisfies_test?(1, 5)).to be_truthy
  end

  it "detects not north of a line" do
    expect(ChapterBoundary.new(ChapterBoundary::NORTH_OF, x1: 1, y1: 1, x2: 5, y2: 5 ).satisfies_test?(5, 1)).to be_falsy
  end

  it "detects north of or equal a line" do
    expect(ChapterBoundary.new(ChapterBoundary::NORTH_OF_OR_EQUAL, x1: 1, y1: 1, x2: 5, y2: 5 ).satisfies_test?(2, 2)).to be_truthy
  end

  it "detects not north of or equal a line" do
    expect(ChapterBoundary.new(ChapterBoundary::NORTH_OF_OR_EQUAL, x1: 1, y1: 1, x2: 5, y2: 5 ).satisfies_test?(5, 1)).to be_falsy
  end

  it "detects south of a line" do
    expect(ChapterBoundary.new(ChapterBoundary::SOUTH_OF, x1: 1, y1: 1, x2: 5, y2: 5 ).satisfies_test?(5, 1)).to be_truthy
  end

  it "detects not south of a line" do
    expect(ChapterBoundary.new(ChapterBoundary::SOUTH_OF, x1: 1, y1: 1, x2: 5, y2: 5 ).satisfies_test?(1, 5)).to be_falsy
  end

  it "detects south of or equal a line" do
    expect(ChapterBoundary.new(ChapterBoundary::SOUTH_OF_OR_EQUAL, x1: 1, y1: 1, x2: 5, y2: 5 ).satisfies_test?(2, 2)).to be_truthy
  end

  it "detects not south of or equal a line" do
    expect(ChapterBoundary.new(ChapterBoundary::SOUTH_OF_OR_EQUAL, x1: 1, y1: 1, x2: 5, y2: 5 ).satisfies_test?(1, 5)).to be_falsy
  end
end
