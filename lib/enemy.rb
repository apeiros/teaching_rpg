# encoding: utf-8

require 'yaml'
require 'set'
require 'loot'

class Enemy
  RangeSpawnAttributes = %w[
    health_points
  ].to_set
  RangeAttributes = %w[
    armor
    attack
    experience
    gold
  ].to_set

  def self.range_attr_reader(*names)
    names.each do |name|
      class_eval <<-EOC
        def #{name}
          rand(@#{name})
        end
      EOC
    end
  end

  attr_reader :name, :health_points, :attack, :armor, :experience, :gold
  range_attr_reader *RangeAttributes

  def self.from_file(path)
    data  = YAML.load_file(path)
    klass = data.delete('class')
    if klass
      Enemies.const_get(klass).new(data)
    else
      new(data)
    end
  end

  def initialize(description)
    extract_ivars(description)
  end

  def alive?
    @health_points > 0
  end
  def dead?
    !alive?
  end

  def take_physical_damage(damage)
    damage -= armor
    damage  = 0 if damage < 0
    @health_points -= damage
    @health_points  = 0 if @health_points < 0

    damage
  end

  def magic_points
    0
  end

  def loot
    Loot.new(experience, gold, [])
  end

  def spawn
    enemy = dup
    enemy.initialize_spawn
    enemy
  end

  def initialize_spawn
    RangeSpawnAttributes.each do |name|
      ivar = :"@#{name}"
      instance_variable_set(ivar, rand(instance_variable_get(ivar)))
    end
  end

private
  def extract_ivars(hash)
    hash.each do |name, value|
      if RangeAttributes.include?(name) || RangeSpawnAttributes.include?(name)
        if value.is_a?(Array)
          value = value[0]..value[1]
        else
          value = value..value
        end
      end
      instance_variable_set(:"@#{name}", value)
    end
  end
end
