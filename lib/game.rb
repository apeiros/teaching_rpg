# encoding: utf-8

require 'map'
require 'hero'
require 'scenes'
require 'screens'
require 'enemy'
require 'inn'
require 'shop'
require 'item'


# handles global game state
class Game
  class <<self
    attr_accessor :rows, :columns
    attr_reader :inns, :enemies, :shops, :items
  end

  @items    = {}
  @shops    = {}
  @inns     = {}
  @enemies  = {}

  def self.spawn(enemy_name)
    @enemies[enemy_name].spawn
  end

  def self.load_all
    @items    = {}
    @shops    = {}
    @inns     = {}
    @enemies  = {}

    Dir.glob('data/enemies/**/*.yaml') do |file|
      enemy = Enemy.from_file(file)
      @enemies[enemy.name] = enemy
    end
    @inns = Hash[YAML.load_file('data/inns.yaml').map { |name, cost_per_night|
      [name, Inn.new(cost_per_night)]
    }]
    Dir.glob('data/enemies/**/*.yaml') do |file|
      shop = Shop.from_file(file)
      @shops[shop.name] = shop
    end
  end

  def self.run
    game = new
    game.run
  end

  def self.warning_screensize
    puts "#{Screen::ClearScreen}WARNING",
         "Your screen seems to small",
         "The game needs 120 cols and 40 rows at least",
         "Please resize your terminal emulation accordingly.",
         "Current size: #{Game.columns} x #{Game.rows}"
    exit 1
  end

  def self.screen_too_small?
    rows < 40 || columns < 120
  end

  attr_reader :scenes, :hero, :map, :shop, :enemy, :cleared_bosses

  def initialize
    @scenes         = []
    @map            = nil
    @hero           = Hero.new('Aldaran')
    @enemy          = nil
    @cleared_bosses = {}
  end

  def defeated?(map, position)
    @cleared_bosses[[map, position.to_a]]
  end

  def defeated(map, position)
    @cleared_bosses[[map, position.to_a]] = true
  end

  def run
    catch(:quit) do
      setup_screen do
        Scenes::Title.run(self)
      end
    end
    quit = Screens::Quit.new
    quit.draw
    quit.terminate
  end

  def setup_screen
    $stdin.noecho do
      hide_cursor do
        yield
      end
    end
  end

  def hide_cursor
    $stdout.print "\e[?25l"
    $stdout.flush
    yield
  ensure
    $stdout.print "\e[?25h"
    $stdout.flush
  end
end
