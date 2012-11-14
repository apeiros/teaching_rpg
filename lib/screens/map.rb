# encoding: utf-8

require 'screen'

module Screens
  class Map < Screen
    def initialize(hero, map)
      @hero = hero
      @map  = map
    end

    def rendered
      hero_stats(@hero)+map_slice+help
    end

    def map_slice
      @map.slice(0,0,120,38)
    end

    def help
      key_map_help(
        'W'  => 'Up',
        'A'  => 'Left',
        'S'  => 'Right',
        'D'  => 'Down',
        'Q'  => 'Quit'
      )
    end
  end
end
