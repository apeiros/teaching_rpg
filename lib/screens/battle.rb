# encoding: utf-8

require 'screen'

module Screens
  class Battle < Screen
    LogSize = ScreenHeight-3

    def initialize(hero, enemy)
      @hero   = hero
      @enemy  = enemy
      @log    = ["You encounter a #{@enemy.name}"]
    end

    def report(event)
      @log << event
    end

    def rendered
      unit_stats(@hero)+unit_stats(@enemy)+battle_log+battle_help
    end

    def battle_log
      log   = @log.last(LogSize)
      fill  = LogSize-log.size
      log.concat(['']*fill) if fill > 0

      log.map { |line| "\e[38;5;#{Black};48;5;#{White}m"+ljust(line) }.join
    end

    def battle_help
      key_map_help(
        'A' => 'Attack',
        'B' => 'Block',
        'I' => 'Use Item',
        'R' => 'Retreat',
        'Q' => 'Quit'
      )
    end
  end
end
