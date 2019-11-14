
class ChapterBoundary
  NORTH_OF =          'north_of'
  NORTH_OF_OR_EQUAL = 'north_of_or_equal'
  SOUTH_OF =          'south_of'
  SOUTH_OF_OR_EQUAL = 'south_of_or_equal'
  EAST_OF =           'east_of'
  EAST_OF_OR_EQUAL =  'east_of_or_equal'
  WEST_OF =           'west_of'
  WEST_OF_OR_EQUAL =  'west_of_or_equal'

  EAST_WEST_BOUNDARIES = [EAST_OF, EAST_OF_OR_EQUAL, WEST_OF, WEST_OF_OR_EQUAL]

  def initialize(boundary_type, x1: nil, y1: nil, x2: nil, y2: nil, x: nil)
    @boundary_type = boundary_type
    if EAST_WEST_BOUNDARIES.include?(@boundary_type)
      raise ArgumentError.new("x is required") unless x
      @x = x
    else
      raise ArgumentError.new("x1, y1, x2, and y2 are required") unless x1 && y1 && x2 && y2
      @x1, @y1, @x2, @y2 = x1, y1, x2, y2
      raise "infinite slope #{@x1}, #{@y1}, #{@x2}, #{@y2}" if  (x1.to_f - x2.to_f) == 0.0
      @m = (y1.to_f - y2.to_f) / (x1.to_f - x2.to_f)
      @b = y1.to_f - @m * x1.to_f
    end
  end

  def satisfies_test?(x, y)
    case @boundary_type
    when NORTH_OF
      y >  @m * x + @b
    when NORTH_OF_OR_EQUAL
      y >= @m * x + @b
    when SOUTH_OF
      y <  @m * x + @b
    when SOUTH_OF_OR_EQUAL
      y <= @m * x + @b
    when EAST_OF
      x >  @x
    when EAST_OF_OR_EQUAL
      x >= @x
    when WEST_OF
      x <  @x
    when WEST_OF_OR_EQUAL
      x <= @x
    end
  end

  def to_s
    if EAST_WEST_BOUNDARIES.include?(@boundary_type)
      "#{@boundary_type}, x: #{@x}"
    else
      "#{@boundary_type}, x1: #{@x1}, y1: #{@y1}, x2: #{@x2}, y2: #{@y2}"
    end
  end
end