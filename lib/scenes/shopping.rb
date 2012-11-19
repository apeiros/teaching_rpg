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
      if @screen.highlighted_item.quantity > 0 && @screen.hero.gold >= @screen.highlighted_item.price
        @screen.hero.gold                 -= @screen.highlighted_item.price
        @screen.highlighted_item.quantity -= 1
        @screen.hero.backpack.add(@screen.highlighted_item.item)
      else
        beep
      end
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
  end
end



