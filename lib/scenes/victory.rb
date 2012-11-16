# encoding: utf-8

require 'scene'

module Scenes
  class Victory < Scene
    def initialize(*)
      super
      @screen = Screens::Text.new(
        text: "You have eliminated all enemies, congratulation!",
        keys: {'Q' => 'Exit'}
      )
    end

    def main
      @screen.draw
      expect_input 'q' => :exit
    end
  end
end
