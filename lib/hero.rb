# encoding: utf-8

# Our hero actors are represented by this class
class Hero
  def initialize(name)
    @name           = name
    @health_points  = 100   # every hero starts with 100 health points
  end

  def hit(damage)
    @health_points -= damage
  end
  
  def health_points
    @health_points
  end
  
  def alive?
    @health_points > 0
  end
end
