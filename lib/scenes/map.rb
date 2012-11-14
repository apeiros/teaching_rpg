# encoding: utf-8

require 'scene'

module Scenes
  class Map < Scene

    def initialize(game, level)
      super(game)
      load_map_file(level)
      @screen = Screens::Map.new(game.hero, @map)
    end

    def main
      @screen.draw
      expect_input 'w' => :move_up,
                   'a' => :move_left,
                   's' => :move_down,
                   'd' => :move_right,
                   'q' => :quit
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
      if moved? && enemy_encounter?
        @screen.draw
        sleep 0.5
        Scenes::Battle.run(@game, @map)
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

__END__
if @map.enemies.empty?
  reprint "This dungeon is cleared, congratulations"
  throw(:exit)
else
  render_map
end
