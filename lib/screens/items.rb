# encoding: utf-8

require 'screen'

module Screens
  class Items < Screen
    attr_reader   :hero
    attr_accessor :selected, :position

    def initialize(hero)
      @hero     = hero
      @selected = 0
      @position = 0
    end

    def move_up?
      @selected > 0
    end

    def move_up
      @selected -= 1
    end

    def move_down?
      @selected+1 < @hero.backpack.size
    end

    def move_down
      @selected += 1
    end

    def rendered
      hero_stats(@hero)+item_list+item_description+help
    end

    def item_list
      scroll(
        @hero.backpack.map.with_index { |item, index|
          amount = @hero.backpack.amount(item)
          bg_color = @selected == index ? Cyan : White
          ljust(
            "#{FgBlack}\e[48;5;#{bg_color}m%3d %-16s%s" % [amount, item.display_type, item.name],
            bg_color
          )
        },
        screen_height-4,
        screen_width,
        @position
      )
    end

    def item_description
      box(@hero.backpack[@selected].description, padding: 1, height: 2, background: 220)
    end

    def help
      key_map_help(
        'W'     => 'Up',
        'S'     => 'Down',
        'Space' => 'Select Item',
        'Q'     => 'Exit'
      )
    end
  end
end
