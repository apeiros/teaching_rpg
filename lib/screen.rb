# encoding: utf-8

module Screen
  ScreenHeight = 40
  ScreenWidth  = 120

  def key_map_help(keys)
    size = keys.size*4+keys.values.inject(0) { |s,a| s+a.length }

    keys.map { |key, action|
      "\e[38;5;226;48;5;0;1m #{key} \e[0m\e[38;5;15;48;5;0m#{action} \e[0m"
    }.join("")+"\e[48;5;0m"+(" "*(ScreenWidth-size))+"\e[0m"
  end

  def unit_stats(unit)
    "\e[38;5;15;48;5;0;1m #{'%16s' % unit.name} " \
    "\e[38;5;9;48;5;0m HP #{'%4d' % unit.health_points} " \
    "\e[38;5;14;48;5;0m MP #{'%4d' % unit.magic_points} " \
    "#{' '*(ScreenWidth-36)}\e[0m\n"
  end
end
