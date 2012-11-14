# encoding: utf-8

require 'io/console'

class Screen
  ScreenHeight  = 40
  ScreenWidth   = 120
  ClearScreen   = "\e[2J"
  ResetCursor   = "\e[1;1H"
  ResetColor    = "\e[0m"

  Black = 16
  White = 231

  def screen_height
    ScreenHeight
  end

  def screen_width
    ScreenWidth
  end

  def clear
    print ClearScreen
    flush
  end

  def draw
    print ResetCursor
    print rendered.chomp
    flush
  end

  def print(*args)
    $stdout.print(*args)
  end

  def flush
    $stdout.flush
  end

  def ljust(text, bg=nil, reset=true)
    size        = char_count(text)
    padding     = ' '*(screen_width-size)
    background  = bg && "\e[48;5;#{bg}m"
    reset       = reset ? ResetColor : nil

    "#{text}#{background}#{padding}#{reset}\n"
  end

  def rjust(text, bg=nil, reset=true)
    size        = char_count(text)
    padding     = ' '*(screen_width-size)
    background  = bg && "\e[48;5;#{bg}m"
    reset       = reset ? ResetColor : nil

    "#{background}#{padding}#{text}#{reset}\n"
  end

  def center(text, bg=nil, reset=true)
    size          = char_count(text)
    remaining     = (screen_width-size)
    padding_width = remaining/2
    lpadding      = ' '*padding_width
    rpadding      = ' '*(padding_width+(remaining.odd? ? 1 : 0))
    background    = bg && "\e[48;5;#{bg}m"
    reset         = reset ? ResetColor : nil

    "#{background}#{lpadding}#{text}#{background}#{rpadding}#{reset}\n"
  end

  def char_count(text)
    text.gsub(/\e\[[^m]*m/, '').length
  end

  def key_map_help(keys)
    size = keys.size*4+keys.values.inject(0) { |s,a| s+a.length }

    ljust("\e[48;5;0m"+keys.map { |key, action|
      "\e[38;5;226;1m #{key} \e[38;5;15m#{action} "
    }.join, 0)
  end

  def unit_stats(unit)
    ljust(
      "\e[38;5;15;48;5;0;1m #{'%16s' % unit.name} " \
      "\e[38;5;9m #{'%4d' % unit.health_points} HP " \
      "\e[38;5;14m #{'%4d' % unit.magic_points} MP ",
      0
    )
  end

  def hero_stats(unit)
    ljust(
      "\e[38;5;15;48;5;0;1m #{'%16s' % unit.name} " \
      "\e[38;5;9m #{'%4d' % unit.health_points} HP " \
      "\e[38;5;14m #{'%4d' % unit.magic_points} MP " \
      "\e[38;5;11m #{'%5d' % unit.gold}$ ",
      0
    )
  end
end
