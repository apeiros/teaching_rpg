# encoding: utf-8

require 'scene'
require 'scenes'
  
module Scenes
  class Shopping < Scene
    ShopItem = Struct.new(:type, :name, :quantity, :price, :desc)
    def initialize(game, items = [ShopItem.new('Use', 'Apple', 20, 5, 'A pretty green apple'), ShopItem.new('Helmet', 'Wool Cap', 1, 200, 'This is desc of wool cap') ] )
      super(game)    
      @screen = Screens::Shop.new(@game.hero, items )
    end
    
    def main
      @screen.draw
      expect_input 'w' => :move_up,
                   'a' => :move_up,
                   's' => :move_down,
                   'd' => :move_down,
                   ' ' => :choose,
                   'q' => :quit
    end
    
    def move_up
      if @screen.cursor > 1 
        @screen.cursor -= 1
        @screen.draw
      else 
        beep
      end      
    end
    
    def move_down
      if @screen.cursor < 37
        @screen.cursor += 1
        @screen.draw
      else 
        beep
      end
    end 
    
     
  end
end
               
    
      
