# encoding: utf-8

require 'items'

# Our hero actors are represented by this class
class Hero
  attr_accessor :helmet, :gloves, :breastplate, :trousers, :boots, :shield
  attr_accessor :sword, :blocking
  attr_reader :name, :health_points, :gold, :backpack

  def initialize(name)
    @name               = name
    @max_health_points  = 100
    @health_points      = 100   # every hero starts with 100 health points
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

  def heal(amount)
    @health_points += amount
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

  def health_points
    @health_points
  end

  def magic_points
    0
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
