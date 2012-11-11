# encoding: utf-8
require 'io/console'
require 'map'



# handles UI
class Game
  ClearScreen = "\e[2J\e[1;1H" # clear screen and move to 0:0
  ResetCursor = "\e[1;1H"

  class <<self
    attr_accessor :rows, :columns
  end

  def self.run
    game = new
    game.title_screen
    sleep 0.5
    game.load_map_file('data/maps/level_00.txt')
    catch(:exit) do
      game.setup_screen do
        game.map_loop
      end
    end
    game.exit_screen
  end

  def initialize
    @map = nil
  end

  def title_screen
    puts "#{ClearScreen}Welcome to RubyRPG","","",""
  end

  def exit_screen
    puts "#{ClearScreen}Good bye",""
  end

  def load_map_file(path)
    @map = Map.read_file(path)
  end

  def map_loop
    puts ClearScreen+ResetCursor
    puts @map.rendered+"\n"+map_help+ResetCursor
    while char = $stdin.getch
      case char
        when "a" then @map.move_left
        when "w" then @map.move_up
        when "s" then @map.move_down
        when "d" then @map.move_right
        when "q" then throw(:exit)
      end
      puts @map.rendered+"\n"+map_help+ResetCursor
    end
  end

  def map_help
    "\e[38;5;226;48;5;0;1m W \e[0m\e[38;5;15;48;5;0mUP \e[0m" \
    "\e[38;5;226;48;5;0;1m S \e[0m\e[38;5;15;48;5;0mDOWN \e[0m" \
    "\e[38;5;226;48;5;0;1m A \e[0m\e[38;5;15;48;5;0mLEFT \e[0m" \
    "\e[38;5;226;48;5;0;1m D \e[0m\e[38;5;15;48;5;0mRIGHT \e[0m" \
    "\e[48;5;0m"+(" "*(@map.width-31))+"\e[0m"
  end

  def setup_screen
    $stdin.noecho do
      hide_cursor do
        yield
      end
    end
  end

  def hide_cursor
    print "\e[?25l"
    $stdout.flush
    yield
  ensure
    print "\e[?25h"
    $stdout.flush  
  end
end

Game.rows, Game.columns = $stdin.winsize
trap("SIGWINCH") do
  Game.rows, Game.columns = $stdin.winsize
end


