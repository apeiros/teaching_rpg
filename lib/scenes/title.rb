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
      Scenes::Map.run(@game, 0)
    end

    def from_title_to_help
      Scenes::Help.run(@game)
    end
  end
end
