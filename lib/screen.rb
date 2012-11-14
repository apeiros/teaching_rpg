# encoding: utf-8

require 'io/console'

class Screen
  ScreenHeight  = 40
  ScreenWidth   = 120
  ClearScreen   = "\e[2J"
  ResetCursor   = "\e[1;1H"
  ResetColor    = "\e[0m"

  Black   = 16
  White   = 231
  Red     = 196
  Green   = 46
  Blue    = 21
  Yellow  = 226
  Cyan    = 51
  Violet  = 201

  FgBlack   = "\e[38;5;16m"
  FgWhite   = "\e[38;5;231m"
  FgRed     = "\e[38;5;196m"
  FgGreen   = "\e[38;5;46m"
  FgBlue    = "\e[38;5;21m"
  FgYellow  = "\e[38;5;226m"
  FgCyan    = "\e[38;5;51m"
  FgViolet  = "\e[38;5;201m"

  BgBlack   = "\e[48;5;16m"
  BgWhite   = "\e[48;5;231m"
  BgRed     = "\e[48;5;196m"
  BgGreen   = "\e[48;5;46m"
  BgBlue    = "\e[48;5;21m"
  BgYellow  = "\e[48;5;226m"
  BgCyan    = "\e[48;5;51m"
  BgViolet  = "\e[48;5;201m"

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

  def scroll(ary, height, width, position, background=White)
    ary  = ary[position, height]
    fill = height - ary.length
    ary.concat([ljust('', background)]*fill) if fill > 0

    ary.join
  end

  def char_count(text)
    text.gsub(/\e\[[^m]*m/, '').length
  end

  def key_map_help(keys)
    size = keys.size*4+keys.values.inject(0) { |s,a| s+a.length }

    ljust("\e[48;5;#{Black}m"+keys.map { |key, action|
      "\e[38;5;226;1m #{key} \e[38;5;#{White}m#{action} "
    }.join, 0)
  end

  def unit_stats(unit)
    ljust(
      "\e[38;5;#{White};48;5;#{Black};1m #{'%16s' % unit.name} " \
      "\e[38;5;#{Red}m #{'%4d' % unit.health_points} HP " \
      "\e[38;5;#{Cyan}m #{'%4d' % unit.magic_points} MP ",
      0
    )
  end

  def hero_stats(unit)
    ljust(
      "\e[38;5;#{White};48;5;#{Black};1m #{'%16s' % unit.name} " \
      "\e[38;5;#{Red}m #{'%4d' % unit.health_points} HP " \
      "\e[38;5;#{Cyan}m #{'%4d' % unit.magic_points} MP " \
      "\e[38;5;#{Yellow}m #{'%5d' % unit.gold}$ ",
      0
    )
  end
end