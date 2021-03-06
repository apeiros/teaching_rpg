# encoding: utf-8

require 'io/console'

class Screen
  ScreenHeight  = 40
  ScreenWidth   = 120
  ClearScreen   = "\e[2J"
  ResetCursor   = "\e[1;1H"
  ResetColor    = "\e[0m"
  CursorToDebug = "\e[41;1H"
  WhiteScreen   = "\e[2J\e[1;1H\e[48;5;231m#{(' '*120+"\n")*40}\e[0m\e[1;1H"

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

  def buffer(line)
    @buffer << line
  end

  def draw
    @buffer   = []
    returned  = rendered
    returned  = @buffer.join unless @buffer.empty?

    print ResetCursor
    print returned.chomp
    flush
  end

  def print(*args)
    $stdout.print(*args)
  end

  def flush
    $stdout.flush
  end

  # @option options [Integer] :foreground
  #   The foreground/text color. Defaults to Black.
  # @option options [Integer] :background
  #   The background color. Defaults to White.
  # @option options [Boolean] :bold
  #   Whether the tet should be bold. Defaults to false.
  # @option options [Symbol] :align
  #   Alignment of the text. :left, :center or :right. Defaults to :left.
  # @option options [Integer] :width
  #   The width of the box. Defaults to the screen width.
  # @option options [Integer] :height
  #   The height of the box. Defaults to the number of lines + padding.
  # @option options [Integer, Array<Integer>] :padding
  #   The padding. If a single integer is given, it is treated as left/right padding.
  #   If an array of 2 integers is given, the first is used as top/bottom, second is used as left/right.
  #   If an array of 4 integers is given, they are used as top, right, bottom, left padding, in that order.
  #   Unspecified paddings default to 0.
  def box(text, options={})
    text                    = text.chomp
    foreground              = options.fetch(:foreground, Black)
    background              = options.fetch(:background, White)
    bold                    = options.fetch(:bold,       false) ? ';1' : ''
    align                   = options.fetch(:align,      :left)
    width                   = options.fetch(:width) { screen_width }
    padt,padr,padb,padl     = expand_padding(options.fetch(:padding, 0)) # top, right, bottom, left - like css
    height                  = options.fetch(:height) { text.count("\n")+1+padt+padb }
    padts,padbs             = "\n"*padt,"\n"*padb
    width_after_padding     = width-padl-padr
    lines                   = word_wrap(padts+text+padbs, width_after_padding).split(/\n/).first(height)
    lines.concat(['']*(height-lines.size))

    "\e[38;5;#{foreground};48;5;#{background}#{bold}m"+
      lines.map { |line| line(line, width, align, padl, padr) }.join+
      "\e[0m"
  end

  def expand_padding(padding)
    if padding.is_a?(Integer)
      [0, padding, 0, padding]
    elsif padding.size == 2
      padding.values_at(0,1,0,1)
    else
      padding
    end
  end

  def word_wrap(text, width=screen_width)
    text.gsub(/(.{1,#{width}})( +|$\n?)|(.{1,#{width}})/, "\\1\\3\n")
  end

  def line(text, width=screen_width, align=:left, lpad=0, rpad=0)
    size  = char_count(text)
    pad   = width-size-lpad-rpad
    case align
      when :left
        rpad += pad
      when :right
        lpad += pad
      when :center
        lipad = pad/2
        ripad = pad-lipad
        lpad  += lipad
        rpad  += ripad
      else
        raise ArgumentError, "Unknown alignment #{align.inspect}"
    end
    "#{' '*lpad}#{text}#{' '*rpad}\n"
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

  def debug(text)
    print CursorToDebug+ResetColor+text+ResetCursor
    flush
  end
  def debugi(obj)
    debug obj.inspect
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
    ljust("\e[48;5;#{Black}m"+keys.map { |key, action|
      "\e[38;5;226;1m #{key} \e[38;5;#{White}m#{action} "
    }.join, Black)
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
      "\e[0;38;5;#{White};48;5;#{Black}m L#{unit.level} (#{unit.experience} EXP)" \
      "\e[38;5;#{Red}m #{'%4d' % unit.health_points} HP " \
      "\e[38;5;#{Cyan}m #{'%4d' % unit.magic_points} MP " \
      "\e[38;5;#{Yellow}m #{'%5d' % unit.gold}$ ",
      0
    )
  end
end
