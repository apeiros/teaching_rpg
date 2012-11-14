# encoding: utf-8

require 'scene'

module Scenes
  class SelectItem < Scene

    attr_reader :action

    def initialize(*)
      super
      @screen = Screens::Items.new(@game.hero)
    end

    def main
      @screen.draw
      expect_input 'q'  => :exit,
                   'w'  => :move_up,
                   's'  => :move_down,
                   ' '  => :use,
                   "\n" => :use
    end

    def move_up
      @screen.selected -= 1
      @screen.selected = 0 if @screen.selected < 0
    end

    def move_down
      @screen.selected += 1
      @screen.selected = @game.hero.backpack.size-1 if @screen.selected > @game.hero.backpack.size-1
    end

    def use
      item, amount = @game.hero.backpack.to_a[@screen.selected]
      @game.hero.backpack.remove(item)
      item.apply(@game.hero)
      @action = item.action

      exit
    end
  end
end
