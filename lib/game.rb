# encoding: utf-8
require 'io/console'
require 'map'
require 'hero'
require 'enemies'
require 'battlescreen'
require 'screen'


# handles UI
class Game
  ClearScreen = "\e[2J\e[1;1H" # clear screen and move to 0:0
  ResetCursor = "\e[0;0H"

  include Screen

  class <<self
    attr_accessor :rows, :columns
  end

  def self.run
    game = new
    game.title_screen
    sleep 0.5
    game.load_map_file('data/maps/level_00')
    catch(:exit) do
      game.setup_screen do
        game.map_loop
      end
    end
    game.exit_screen
  end

  def initialize
    @map    = nil
    @hero   = Hero.new('Aldaran')
    @enemy  = nil
  end

  def title_screen
    reprint "#{ClearScreen}Welcome to RubyRPG","","",""
  end

  def exit_screen
    reprint "#{ClearScreen}Good bye",""
  end

  def load_map_file(path)
    @map = Map.read_file(path)
  end

  def map_loop
    render_map
    while char = $stdin.getch
      @previous_position = @map.player_position.dup
      case char
        when "a" then @map.move_left
        when "w" then @map.move_up
        when "s" then @map.move_down
        when "d" then @map.move_right
        when "q" then throw(:exit)
      end
      render_map
      if moved? && enemy_encounter?
        sleep 0.5
        battle_loop
        sleep 0.5
        if @map.enemies.empty?
          reprint "This dungeon is cleared, congratulations"
          throw(:exit)
        else
          render_map
        end
      end
    end
  end

  def reprint(*args)
    $stdout.print ClearScreen+ResetCursor+args.join("\n")
    $stdout.flush
  end

  def print(*args)
    $stdout.print(args.join("\n"))
    $stdout.flush
  end

  def render_map
    reprint hero_stats+"\n"+@map.rendered+"\n"+map_help+ResetCursor
  end

  def moved?
    @previous_position != @map.player_position
  end

  def enemy_encounter?
    rand < @map.enemy_probability
  end

  def battle_loop
    pick_enemy

    @battle_screen = BattleScreen.new(@hero, @enemy)
    reprint @battle_screen.rendered
    sleep 0.5
    flush_input
    @battle_screen.report "Press space to continue"
    reprint @battle_screen.rendered
    get_space
    @battle_screen.report "You have initiative"
    reprint @battle_screen.rendered

    retreated = catch(:retreat) do
      while @hero.alive? && @enemy.alive?
        case $stdin.getch
          when /a/i then attack
          when /r/i then retreat
          when /q/i then throw(:exit)
        end
        reprint @battle_screen.rendered
        if @enemy.alive?
          sleep 0.5
          damage_dealt = @hero.take_physical_damage @enemy.attack
          @battle_screen.report "#{@enemy.name} attacks you and deals #{damage_dealt}"
          reprint @battle_screen.rendered
        end
      end
    end
    if retreated
      restaff_enemy 
    elsif @enemy.alive?
      @battle_screen.report "#{@enemy.name} you died. Game over. Press space to continue."
    else
      @battle_screen.report "#{@enemy.name} died. Congratulations, you win! Press space to continue."
    end
    reprint @battle_screen.rendered
    get_space
  end

  def pick_enemy
    enemy_name  = @map.enemies.keys.sample
    @enemy      = Enemies[enemy_name].dup
    @map.enemies[@enemy.name] -= 1
    @map.enemies.delete(@enemy.name) if @map.enemies[@enemy.name] == 0
  end

  def restaff_enemy
    if Enemies[@enemy.name]
      Enemies[@enemy.name] += 1
    else
      Enemies[@enemy.name] = 1
    end
  end

  def attack
    damage_dealt = @enemy.take_physical_damage @hero.attack
    @battle_screen.report "You attack #{@enemy.name} and deal #{damage_dealt}"
  end

  def retreat
    if rand < 0.35
      @battle_screen.report "You successfully retreated"
      throw(:retreat, true)
    else
      @battle_screen.report "You tried to retreat, but failed"
    end
  end

  def flush_input
    $stdin.read_nonblock(1024)
  rescue Errno::EAGAIN
  end

  def battle_screen
  end

  def hero_stats
    unit_stats(@hero)
  end

  def map_help
    "\e[38;5;226;48;5;0;1m W \e[0m\e[38;5;15;48;5;0mUP \e[0m" \
    "\e[38;5;226;48;5;0;1m S \e[0m\e[38;5;15;48;5;0mDOWN \e[0m" \
    "\e[38;5;226;48;5;0;1m A \e[0m\e[38;5;15;48;5;0mLEFT \e[0m" \
    "\e[38;5;226;48;5;0;1m D \e[0m\e[38;5;15;48;5;0mRIGHT \e[0m" \
    "\e[38;5;226;48;5;0;1m Q \e[0m\e[38;5;15;48;5;0mQUIT \e[0m" \
    "\e[48;5;0m"+(" "*(@map.width-39))+"\e[0m"
  end

  def battle_help
    "\e[38;5;226;48;5;0;1m A \e[0m\e[38;5;15;48;5;0mAttack \e[0m" \
    "\e[48;5;0m"+(" "*(@map.width-10))+"\e[0m"
  end

  def setup_screen
    $stdin.noecho do
      hide_cursor do
        yield
      end
    end
  end

  def get_space
    begin
      char = $stdin.getch
    end until char == ' '
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

Game.rows, Game.columns = $stdin.winsize
trap("SIGWINCH") do
  Game.rows, Game.columns = $stdin.winsize
end


