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

    def rendered
      s=[]
      
      s << ljust(hero_stats(@hero), Black)
     
      @items.each_with_index do |item, index| 
        if index == @cursor
          if index.even?
            s << ljust("\e[38;5;#{Black};48;5;#{Cyan}m "*20 + "     " + " "*(3-item.quantity.to_s.length) + "#{item.quantity}x "+" "*(12-item.type.length) +"#{item.type} "+" "*(16-item.name.length)+"#{item.name}"+"            Price: " + " "*(5-item.price.to_s.length) + "#{item.price}$", Cyan)
          else 
            s << ljust("\e[38;5;#{Black};48;5;#{White}m "*20 + "     " + " "*(3-item.quantity.to_s.length) + "#{item.quantity}x "+" "*(12-item.type.length) +"#{item.type} "+" "*(16-item.name.length)+"#{item.name}"+"            Price: " + " "*(5-item.price.to_s.length) + "#{item.price}$", White)
          end
        else       
          if index.odd?
            s << ljust("\e[38;5;#{Black};48;5;#{Cyan}m "*20 + "     " + " "*(3-item.quantity.to_s.length) + "#{item.quantity}x "+" "*(12-item.type.length) +"#{item.type} "+" "*(16-item.name.length)+"#{item.name}"+"            Price: " + " "*(5-item.price.to_s.length) + "#{item.price}$", Cyan)
          else 
            s << ljust("\e[38;5;#{Black};48;5;#{White}m "*20 + "     " + " "*(3-item.quantity.to_s.length) + "#{item.quantity}x "+" "*(12-item.type.length) +"#{item.type} "+" "*(16-item.name.length)+"#{item.name}"+"            Price: " + " "*(5-item.price.to_s.length) + "#{item.price}$", White)
          end  
        end  
      end
      
      @items.size.upto(@max_items-1) do | index |
        if index.odd?
        s << ljust("\e[38;5;#{White};48;5;#{Cyan}m "*120 , Cyan)
        else
        s  << ljust("\e[38;5;#{White};48;5;#{White}m "*120 , White)
        end      
      end
      if @items[@cursor]
        itemdesc= @items[@cursor].desc
        lineone = itemdesc
        linetwo = ''
        end
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
