# encoding: utf-8

require 'scene'

module Scenes
  class Map < Scene

    def initialize(game, level)
      super(game)
      load_map_file(level)
      @screen = Screens::Map.new(game.hero, @map)
    end

    def victory?
      @map.enemies.empty?
    end

    def main
      @screen.draw
      expect_input 'w' => :move_up,
                   'a' => :move_left,
                   's' => :move_down,
                   'd' => :move_right,
                   'i' => :use_item,
                   'q' => :quit
    end

    def use_item
      Scenes::SelectItem.run(@game)
    end

    def move_left
      move { @map.move_left }
    end

    def move_up
      move { @map.move_up }
    end

    def move_down
      move { @map.move_down }
    end

    def move_right
      move { @map.move_right }
    end

    def move
      @previous_position = @map.player_position.dup
      yield
      if moved?
        ax, ay = *@map.player_position
        rx, ry = *@map.relative_position
        mw     = @map.width
        mh     = @map.height
        cx     = @map.clipping_x
        cy     = @map.clipping_y
        dur    = 0.5

        if rx < 20 && cx > 0
          @screen.scroll_x([@map.clipping_x-40, 0].max, dur)
        elsif rx > @map.screen_width-20 && cx+@map.screen_width < mw
          @screen.scroll_x([@map.clipping_x+40, @map.width-@map.screen_width].min, dur)
        elsif ry < 8 && cy > 0
          @screen.scroll_y([@map.clipping_y-16, 0].max, dur)
        elsif ry > @map.screen_height-8 && cy+@map.screen_height < mh
          @screen.scroll_y([@map.clipping_y+16, @map.height-@map.screen_height].min, dur)
        end

        if enemy_encounter?
          @screen.draw
          sleep 0.5
          Scenes::Battle.run(@game, @map)
          @exit = true if @map.enemies.empty?
        end
      end
    end

    def moved?
      @previous_position != @map.player_position
    end

    def enemy_encounter?
      rand < @map.enemy_probability
    end

    def load_map_file(level)
      @map = ::Map.read_file(path_for_level(level))
    end

    def path_for_level(level)
      'data/maps/level_%02d' % level
    end
  end
end
