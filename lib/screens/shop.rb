# encoding: utf-8

require 'screen'

module Screens
  class Shop < Screen
    attr_accessor :cursorline
    def initialize(hero, items)
      @hero  = hero
      @items  = items
      @cursorline = 41
    end

    def rendered
      s=[]
      #hero_stats(@hero)
      s << ljust("LiNe WhErE Hero Stats will GOOOOOoOo", Black)
      counter = 0
      @items.each do | item | 
        lspacer = 40 - ( item.type.length + item.name.length + item.quantity.to_s.length + 4 )
        counter += 1
        if counter == @cursorline
          if !counter.odd?
          s << ljust("\e[38;5;#{Black};48;5;#{Cyan}m "*20 + "     " + " "*(3-item.quantity.to_s.length) + "#{item.quantity}x "+" "*(12-item.type.length) +"#{item.type} "+" "*(16-item.name.length)+"#{item.name}"+"            Price: " + " "*(5-item.price.to_s.length) + "#{item.price}$", Cyan)
          else 
          s << ljust("\e[38;5;#{Black};48;5;#{White}m "*20 + "     " + " "*(3-item.quantity.to_s.length) + "#{item.quantity}x "+" "*(12-item.type.length) +"#{item.type} "+" "*(16-item.name.length)+"#{item.name}"+"            Price: " + " "*(5-item.price.to_s.length) + "#{item.price}$", White)
          end
        end
        if counter.odd?
          s << ljust("\e[38;5;#{Black};48;5;#{Cyan}m "*20 + "     " + " "*(3-item.quantity.to_s.length) + "#{item.quantity}x "+" "*(12-item.type.length) +"#{item.type} "+" "*(16-item.name.length)+"#{item.name}"+"            Price: " + " "*(5-item.price.to_s.length) + "#{item.price}$", Cyan)
        else 
          s << ljust("\e[38;5;#{Black};48;5;#{White}m "*20 + "     " + " "*(3-item.quantity.to_s.length) + "#{item.quantity}x "+" "*(12-item.type.length) +"#{item.type} "+" "*(16-item.name.length)+"#{item.name}"+"            Price: " + " "*(5-item.price.to_s.length) + "#{item.price}$", White)
        end
      end
      
      (36-counter).times do | x |
        if (40-counter-x).even?
        s << ljust("\e[38;5;#{White};48;5;#{Cyan}m "*120 , Cyan)
        else
        s  << ljust("\e[38;5;#{White};48;5;#{White}m "*120 , White)
        end      
      end
      if @items[@cursorline]
        itemdesc= @items[@cursorline].desc
        lineone = itemdesc.split('')[0..79]
        linetwo = itemdesc.split('')[80..159]
      end
      s << ljust(" "*20+"#{lineone}", Black)
      s << ljust(" "*20+"#{linetwo}", Black)
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
