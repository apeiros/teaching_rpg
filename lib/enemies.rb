# encoding: utf-8

require 'enemy'

Enemies = Hash[[
  # name, health_points, attack, armor
  Enemy.new('Wabbit', 20, 4, 0),
  Enemy.new('Decaying Corpse', 30, 5, 1),
].map { |enemy| [enemy.name, enemy] }]