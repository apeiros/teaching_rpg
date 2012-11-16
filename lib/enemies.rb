# encoding: utf-8

require 'enemy'

class Enemies
  def self.load_all
    @all = Enemies.new.tap(&:load_directory)
  end

  def self.all
    @all
  end

  def initialize
    @enemies = {}
  end

  def load_directory(path='data/enemies')
    Dir.glob(path.chomp('/')+'/**/*.yaml') do |file|
      add Enemy.from_file(file)
    end
  end

  def add(enemy)
    @enemies[enemy.name] = enemy
  end

  def spawn(name)
    @enemies[name].spawn
  end
end
