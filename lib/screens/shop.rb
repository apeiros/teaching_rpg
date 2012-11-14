# encoding: utf-8

require 'screen'

module Screens
  class Shop < Screen
    def initialize(hero, shop)
      @hero   = hero
      @shop  = shop
    end

    def report(event)
      @log << event
    end

    def rendered
      hero_stats(@hero)
    end

    def battle_log
      log   = @log.last(LogSize)
      fill  = LogSize-log.size
      log.concat(['']*fill) if fill > 0

      log.map { |line| ljust(line) }.join
    end

    def help
      key_map_help(
        'WASD'  => 'Change Selection',
        'Space' => 'Choose',
        'Q'     => 'Exit'
      )
    end
  end
end
