# encoding: utf-8

require 'scene'
require 'scenes'

module Scenes
  class Shopping < Scene
    def initialize(game, shop)
      super(game)
      @shop   = shop
      @screen = Screens::Shop.new(@game.hero, @shop)
    end

    def main
      @screen.draw
      expect_input 'w' => :move_up,
                   'a' => :move_up,
                   's' => :move_down,
                   'd' => :move_down,
                   ' ' => :choose,
                   'q' => :exit
    end

    def choose
      if @screen.hero.gold >= @screen.highlighted_item.price
        @screen.hero.gold -= @screen.highlighted_item.price
        @screen.hero.backpack.add(@screen.highlighted_item)
        @screen.highlighted_item.quantity -= 1
        if @screen.highlighted_item.quantity <= 0
          @screen.highlighted_item.delete
        end
      else
        beep
      end
    end

    def move_up
      if @screen.move_up?
        @screen.cursor -= 1
      else
        beep
      end
    end

    def move_down
      if @screen.move_down?
        @screen.cursor += 1
      else
        beep
      end
    end
  end
end



