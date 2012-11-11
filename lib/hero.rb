# encoding: utf-8

# Our hero actors are represented by this class
class Hero
  attr_accessor :helmet, :gloves, :breastplate, :trousers, :boots, :shield
  attr_accessor :sword
  attr_reader :name, :health_points

  def initialize(name)
    @name           = name
    @health_points  = 100   # every hero starts with 100 health points
    @sword          = 10    # attack
    @helmet         = 0     # initial armor equipment is 0
    @gloves         = 0
    @breastplate    = 0
    @trousers       = 0
    @boots          = 0
    @shield         = 1
  end

  def attack
    @sword
  end

  def take_physical_damage(damage)
    damage -= armor
    damage  = 0 if damage < 0
    @health_points -= damage
    @health_points  = 0 if @health_points < 0

    damage
  end
  
  def health_points
    @health_points
  end
  
  def magic_points
    0
  end

  def alive?
    @health_points > 0
  end

  def armor
    @helmet+@gloves+@breastplate+@trousers+@boots+@shield
  end

  def to_s
    "Hero #{@name}\n  Health: #{@health_points}\n  Armor: #{armor}\n"
  end
end
