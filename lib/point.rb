class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def moved(by_x, by_y)
    self.class.new(@x+by_x, @y+by_y)
  end

  def up(amount=1)
    self.class.new(x, y-amount)
  end

  def left(amount=1)
    self.class.new(x-amount, y)
  end

  def right(amount=1)
    self.class.new(x+amount, y)
  end

  def down(amount=1)
    self.class.new(x, y+amount)
  end

  def within?(rect)
    x.between?(rect.x, rect.max_x) && y.between?(rect.y, rect.max_y)
  end

  def at?(x, y)
    @x == x && @y == y
  end

  def relative_to(point)
    Point.new(@x-point.x, @y-point.y)
  end

  def eql?(other)
    self.class == other.class && @x == other.x && @y == other.y
  end
  alias == eql?

  def hash
    [self.class, @x, @y].hash
  end

  def to_a
    [@x, @y]
  end

  def to_h
    {x: y, y: y}
  end
end
