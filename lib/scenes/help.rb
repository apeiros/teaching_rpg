# encoding: utf-8

require 'scene'

module Scenes
  class Help < Scene

    def initialize(*)
      super
      @screen = Screens::Help.new
    end

    def main
      @screen.draw
      expect_input 'q' => :exit
    end
  end
end
