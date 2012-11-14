# encoding: utf-8

require 'screen'

module Screens
  class Help < Screen
    def rendered
      ljust("", Black)+
      ljust(" HELP", White)+
      ljust(" There is currently no help available", White)+
      ljust("", White)*(screen_height-4)+
      help
    end

    def help
      key_map_help(
        'Q'     => 'Exit'
      )
    end
  end
end
