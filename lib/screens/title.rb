# encoding: utf-8

require 'screen'

module Screens
  class Title < Screen
    def rendered
      ljust("", Black)+
      ljust("", White)+
      center("#{FgBlack}WELCOME", White)+
      center("#{FgBlack}To The Ruby RPG", White)+
      ljust("", White)+
      center("#{FgBlack}Press SPACE to start a new game", White)+
      ljust("", White)*(screen_height-7)+
      help
    end

    def help
      key_map_help(
        'Space' => 'Start New Game',
        'H'     => 'Help',
        'Q'     => 'Quit'
      )
    end
  end
end
