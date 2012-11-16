# encoding: utf-8

require 'screen'

module Screens
  class Shop < Screen
    attr_accessor :cursor
    def initialize(hero, items)
      @hero       = hero
      @items      = items
      @cursor     = 0
      @max_items  = 36
    end

    # returns whether the cursor can be moved down
    def move_down?
      @cursor+1 < @max_items
    end

    # returns whether the cursor can be moved up
    def move_up?
      @cursor > 0
    end

    def rendered
      s=[]

      s << hero_stats(@hero)

      @items.each_with_index do |item, index|
        if index == @cursor
          row_color = 51
        elsif index.even?
          row_color = 251
        else
          row_color = White
        end
        s << ljust("\e[38;5;#{Black};48;5;#{row_color}m "*20 + "     " + " "*(3-item.quantity.to_s.length) + "#{item.quantity}x "+" "*(12-item.type.length) +"#{item.type} "+" "*(16-item.name.length)+"#{item.name}"+"            Price: " + " "*(5-item.price.to_s.length) + "#{item.price}$", row_color)
      end

      @items.size.upto(@max_items-1) do | index |
        if index == @cursor
          row_color = 51
        elsif index.even?
          row_color = 251
        else
          row_color = White
        end
        s << ljust("\e[38;5;#{White};48;5;#{row_color}m "*120 , row_color)
      end
      if @items[@cursor]
        itemdesc= @items[@cursor].desc
        lineone = itemdesc
        linetwo = ''
        s << ljust(" "*20+"#{lineone}", Black)
        s << ljust(" "*20+"#{linetwo}", Black)
      else
        s << ljust("", Black)
        s << ljust("", Black)
      end

      s << help
      s.join
    end

    def help
      key_map_help(
        'WASD'  => 'Change Selection',
        'Space' => 'Choose',
        'Q'     => 'Exit'
      )
    end

  end
end
