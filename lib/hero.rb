# encoding: utf-8

# Our hero actors are represented by this class
class Hero
  attr_accessor :helmet, :gloves, :breastplate, :trousers, :boots
  attr_reader :name, :health_points

  def initialize(name)
    @name           = name
    @health_points  = 100   # every hero starts with 100 health points
    @helmet         = 0     # initial armor equipment is 0
    @gloves         = 0
    @breastplate    = 0
    @trousers       = 0
    @boots          = 0
  end

  def hit(damage)
    damage -= armor
    @health_points -= damage if damage > 0
  end
  
  def health_points
    @health_points
  end
  
  def alive?
    @health_points > 0
  end

  def armor
    @helmet+@gloves+@breastplate+@trousers+@boots
  end

  def to_s
    "Hero #{@name}\n  Health: #{@health_points}\n  Armor: #{armor}\n"
  end
end
