# encoding: utf-8

require 'loot'
require 'luggage'
require 'inspector'

# Our hero actors are represented by this class
class Hero
  include Inspector

  attr_accessor :helmet, :gloves, :breastplate, :trousers, :boots, :shield
  attr_accessor :weapon, :blocking, :gold
  attr_reader   :name, :health_points, :magic_points, :level, :experience, :backpack

  def initialize(name)
    @name               = name
    @level              = 1
    @experience         = 0
    @max_health_points  = 100
    @health_points      = 100   # every hero starts with 100 health points
    @max_magic_points   = 0
    @magic_points       = 0

    @weapon             = 10

    @headgear           = nil
    @gloves             = nil
    @shield             = nil
    @breastplate        = nil
    @trousers           = nil
    @boots              = nil

    @gold               = 100
    @blocking           = false
    @backpack           = Luggage.new(
      100,
      Game.items['Apple']   => 10,
      Game.items['Potion']  =>  2
    )
  end

  def loot(unit)
    looted = unit.loot
    @experience += looted.experience
    @gold       += looted.gold
    if @experience > 1000
      @experience         -= 1000
      @level              += 1
      @max_health_points  += @level*10
      regenerate
    end

    looted
  end



  def regenerate
    @health_points = @max_health_points
    @magic_points  = @max_magic_points
  end

  def heal(amount=nil)
    @health_points += (amount || @max_health_points)
    @health_points = @max_health_points if @health_points > @max_health_points

    amount
  end

  def take_physical_damage(damage)
    armor   = @blocking ? (5+3*armor()) : armor()
    damage -= armor
    damage  = 0 if damage < 0
    @health_points -= damage
    @health_points  = 0 if @health_points < 0

    damage
  end

  def attack
    @weapon
  end

  def alive?
    @health_points > 0
  end
  def dead?
    !alive?
  end

  def armor
    [@helmet, @gloves, @breastplate, @trousers, @boots, @shield].compact.map(&:armor).inject(0, :+)
  end

  def to_s
    "Hero #{@name}\n  Health: #{@health_points}\n  Armor: #{armor}\n"
  end
end
