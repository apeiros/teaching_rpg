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

  attr_reader :scene, :hero, :map, :shop, :enemy

  def initialize
    @scene  = []
    @map    = nil
    @hero   = Hero.new('Aldaran')
    @enemy  = nil
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
