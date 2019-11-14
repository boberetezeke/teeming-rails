class ChapterBoundaries
  attr_reader :boundaries
  def initialize(boundaries)
    @boundaries = boundaries
  end

  def within_boundaries?(x, y)
    @boundaries.map{|chapter_boundary| chapter_boundary.satisfies_test?(x,y)}.select{|result| result}.size ==
      @boundaries.size
  end

  def to_s
    @boundaries.map(&:to_s).join(", ")
  end
end
