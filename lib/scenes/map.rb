# encoding: utf-8

require 'scene'

module Scenes
  class Map < Scene

    def initialize(game, level)
      super(game)
      load_map_file(level)
      @screen = Screens::Map.new(@hero, @map)
    end

    def victory?
      @map.enemies.empty? && @game.cleared_bosses.size == 1
    end

    def main
      @screen.draw
      expect_input 'w' => :move_up,
                   'a' => :move_left,
                   's' => :move_down,
                   'd' => :move_right,
                   'i' => :use_item,
                   'q' => :quit,
                   'b' => :shop
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
      @previous_position = @map.player.dup
      yield
      if moved?
        scroll_map
        if @map.point_of_interest?
          send(*@map.point_of_interest)
        elsif enemy_encounter?
          @screen.draw
          sleep 0.5
          Scenes::Battle.run(@game, @map)
          @exit = true if @map.enemies.empty?
        end
      end
    end

    def moved?
      @previous_position != @map.player
    end

    def enemy_encounter?
      rand < @map.enemy_probability
    end

    def load_map_file(level)
      @map = ::Map.read_file(@game, path_for_level(level))
    end

    def path_for_level(level)
      'data/maps/%s' % level
    end

    def scroll_map
      ax, ay = *@map.player
      rx, ry = *@map.relative_position
      mw     = @map.width
      mh     = @map.height
      cx     = @map.clipping.x
      cy     = @map.clipping.y
      dur    = 0.5

      if rx < 20 && cx > 0
        @screen.scroll_x([@map.clipping.x-40, 0].max, dur)
      elsif rx > @map.screen_width-20 && cx+@map.screen_width < mw
        @screen.scroll_x([@map.clipping.x+40, @map.width-@map.screen_width].min, dur)
      elsif ry < 8 && cy > 0
        @screen.scroll_y([@map.clipping.y-16, 0].max, dur)
      elsif ry > @map.screen_height-8 && cy+@map.screen_height < mh
        @screen.scroll_y([@map.clipping.y+16, @map.height-@map.screen_height].min, dur)
      end
    end

    def shop(*)
      Scenes::Shopping.run(@game)
    end

    def connection(level_name, connection)
      from_map = @map.name
      load_map_file(level_name)
      @map.move_to_connection(from_map, connection)
      @screen = Screens::Map.new(@hero, @map)
    end

    def boss(enemy_name)
      @screen.draw
      sleep 0.5
      scene = Scenes::Battle.run(@game, @map, Game.spawn(enemy_name))
      @game.defeated(@map.name, @map.player) if scene.victory?
      @exit = true if @map.enemies.empty?
    end

    def inn(*)
      screen = Screens::Text.new(
        text: "The hero takes an nap\nYour health and magic points are fully restored.",
        keys: {}
      )
      screen.draw
      sleep 1.5
      @hero.regenerate
      @screen.draw
    end
  end
end
