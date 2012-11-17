# encoding: utf-8

require 'scene'

module Scenes
  class Title < Scene

    def initialize(*)
      super
      @screen = Screens::Title.new
    end

    def main
      @screen.draw
      expect_input ' ' => :from_title_to_map,
                   'h' => :from_title_to_help,
                   'q' => :exit
    end

    def from_title_to_map
      map_scene = Scenes::Map.run(@game, 'village_01')
      if @game.hero.dead?
        Scenes::Defeat.run(@game)
      elsif map_scene.victory?
        Scenes::Victory.run(@game)
      end
    end

    def from_title_to_help
      Scenes::Help.run(@game)
    end
  end
end
