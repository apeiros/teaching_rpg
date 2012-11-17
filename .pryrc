# encoding: utf-8

$LOAD_PATH << File.expand_path('lib')

require 'game'

Game.load_all
H = Hero.new('Alderan')
E = Game.enemies['Wabbit'].spawn()
G = Game.new

class <<self
  def screen
    $stdin.noecho do
      hide_cursor do
        $stdout.print "\e[2J"
        $stdout.flush
        catch(:quit) do
          yield
        end
      end
    end
  rescue Interrupt
  ensure
    $stdout.print "\e[2J\n"
    $stdout.flush
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
