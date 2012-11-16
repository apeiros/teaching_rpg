# encoding: utf-8

require 'scene'
require 'scenes'
  
module Scenes
  class Shopping < Scene
    ShopItem = Struct.new(:type, :name, :quantity, :price, :desc); items = [ShopItem.new('Use', 'Apple', 20, 5, 'A pretty green apple'), ShopItem.new('Helmet', 'Wool Cap', 1, 200, 'This is desc of wool cap')]
    def initialize(game)
      super()     
      @screen = Screens::Shop.new(nil, ShopItem )
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
      
      if @screen.cursorline > 1 
        @screen.cursorline -= 1
        @screen.draw
      else 
       beep
      end
      
    end
    
    def move_down
      if @screen.cursorline < 40
      @screen.cursorline += 1
      @screen.draw
      else 
       beep
      end
    end  
  end

end
               
    
      
