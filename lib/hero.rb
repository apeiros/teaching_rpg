# encoding: utf-8

require 'items'
require 'loot'

# Our hero actors are represented by this class
class Hero
  attr_accessor :helmet, :gloves, :breastplate, :trousers, :boots, :shield
  attr_accessor :sword, :blocking, :gold
  attr_reader :name, :health_points, :magic_points, :level, :experience, :backpack

  def initialize(name)
    @name               = name
    @level              = 1
    @experience         = 0
    @max_health_points  = 100
    @health_points      = 100   # every hero starts with 100 health points
    @max_magic_points   = 0
    @magic_points       = 0
    @sword              = 10    # attack
    @helmet             = 0     # initial armor equipment is 0
    @gloves             = 0
    @breastplate        = 0
    @trousers           = 0
    @boots              = 0
    @shield             = 1
    @gold               = 100
    @blocking           = false
    @backpack           = Items.new(
      Items::HealingItem.new('Apple',   20) => 10,
      Items::HealingItem.new('Potion', 100) =>  2
    )
  end

  def loot(unit)
    looted = unit.loot
    @experience += looted.experience
    @gold       += looted.gold
    if @experience > 1000
      @experience -= 1000
      @level      += 1
      @max_health_points += @level*10
      regenerate
    end

    looted
  end

  def add_item(item)
    unless @backpack[item]
      @backpack << {item => 1}    
    else
      @backpack[item] += 1
    end  
  end
  
  
  def rem_item(item)
    @backpack.delete(item)
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
    @sword
  end

  def alive?
    @health_points > 0
  end
  def dead?
    !alive?
  end

  def armor
    @helmet+@gloves+@breastplate+@trousers+@boots+@shield
  end

  def to_s
    "Hero #{@name}\n  Health: #{@health_points}\n  Armor: #{armor}\n"
  end
end
