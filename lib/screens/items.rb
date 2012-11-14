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

    def rendered
      unit_stats(@hero)+item_list+help
    end

    def item_list
      scroll(
        @hero.backpack.map.with_index { |(item, amount), index|
          bg_color = @selected == index ? Cyan : White
          ljust(
            "#{FgBlack}\e[48;5;#{bg_color}m%3d %-12s%s" % [amount, item.name, item.description],
            bg_color
          )
        },
        screen_height-2,
        screen_width,
        @position
      )
    end

    def help
      key_map_help(
        'W'     => 'Up',
        'S'     => 'Down',
        'Space' => 'Select Item',
        'Q'     => 'Quit'
      )
    end
  end
end
