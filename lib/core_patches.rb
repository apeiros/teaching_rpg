# encoding: utf-8

class Module
  def deep_const_get(name)
    spaces = name.split(/::/)
    if spaces.first.empty?
      base   = ::Object
      spaces.shift
    else
      base   = self
    end

    spaces.inject(base) { |container, constant| container.const_get(constant) }
  end
end

class Object
private
  def extract_ivars(ivars)
    ivars.each do |name, value|
      instance_variable_set(:"@#{name}", value)
    end
  end
end

module Kernel
module_function
  def debugi(obj)
    $stdout.print(Screen::CursorToDebug+obj.inspect)
    $stdout.flush
  end

  def log(obj)
    File.write('log.txt', obj.inspect+"\n", mode: 'a')
  end
end
