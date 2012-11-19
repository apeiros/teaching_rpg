# encoding: utf-8

require 'scene'

module Scenes
  class SelectItem < Scene

    attr_reader :action

    def initialize(*)
      super
      @screen = Screens::Items.new(@hero)
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
      if @screen.move_up?
        @screen.move_up
      else
        beep
      end
    end

    def move_down
      if @screen.move_down?
        @screen.move_down
      else
        beep
      end
    end

    def use
      item = @hero.backpack[@screen.selected]
      @game.hero.backpack.remove(item)
      item.apply(@game.hero)
      @action = item.action
    end
  end
end
