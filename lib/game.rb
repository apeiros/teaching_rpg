# encoding: utf-8

require 'map'
require 'hero'
require 'enemies'
require 'scenes'
require 'screens'


# handles UI
class Game
  class <<self
    attr_accessor :rows, :columns
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

  attr_reader :scenes, :hero, :map, :shop, :enemy, :enemies

  def initialize
    @scenes   = []
    @map      = nil
    @hero     = Hero.new('Aldaran')
    @enemy    = nil
    @enemies  = Enemies.new.tap(&:load_directory)
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
