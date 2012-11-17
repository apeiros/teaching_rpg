# encoding: utf-8

require 'screen'

module Screens
  class Map < Screen
    def initialize(hero, map)
      @hero   = hero
      @map    = map
    end

    def rendered
      hero_stats(@hero)+map_slice+"\n"+help
    end

    def map_slice
      @map.rendered_slice
    end

    def scroll_x(new_clipping_x, duration)
      interval = duration.fdiv((@map.clipping.x-new_clipping_x).abs)
      @map.clipping.x.send(new_clipping_x < @map.clipping.x ? :downto : :upto, new_clipping_x) do |x|
        @map.set_clipping(x, @map.clipping.y)
        draw
        sleep interval
      end
    end

    def scroll_y(new_clipping_y, duration)
      interval = duration.fdiv((@map.clipping.y-new_clipping_y).abs)
      @map.clipping.y.send(new_clipping_y < @map.clipping.y ? :downto : :upto, new_clipping_y) do |y|
        @map.set_clipping(@map.clipping.x, y)
        draw
        sleep interval
      end
    end

    def help
      key_map_help(
        'W'  => 'Up',
        'A'  => 'Left',
        'S'  => 'Down',
        'D'  => 'Right',
        'I'  => 'Use Item',
        'Q'  => 'Quit'
      )
    end
  end
end
