# encoding: utf-8

# Sadly, in ruby <2.0 Object#inspect uses to_s, and will use a redefined to_s. Not even
# Object.instance_method(:inspect).call(obj) gets you around that.
# This module provides something akin to Object#inspect for arbitrary objects.
#
# @example Generic object inspection
#     puts Inspector.inspect_object(some_obj)
#
# @example Including it into a class
#     class Foo
#       include Inspector
#       def to_s() "weee, inspect will not use this" end
#     end
#     Foo.new.inspect
module Inspector
  InstanceVariables   = Object.instance_method(:instance_variables)
  InstanceVariableGet = Object.instance_method(:instance_variable_get)

  def self.inspect_object(obj, seen=nil)
    seen       ||= {}.tap(&:compare_by_identity)
    return inspect_recursion(obj) if seen.has_key?(obj)

    ivars = InstanceVariables.bind(obj).call
    if ivars.empty?
      case obj
        when Symbol, TrueClass, FalseClass, NilClass, Fixnum, Bignum
          obj.inspect
        when String
          seen[obj]   = true
          obj.inspect
        when Array
          seen[obj]   = true
          inspect_array(obj, seen)
        when Hash
          seen[obj]   = true
          inspect_hash(obj, seen)
        else
          seen[obj]   = true
          "\#<#{obj.class}:0x#{(obj.__id__ << 1).to_s(16)}>"
      end
    else
      seen[obj]   = true
      case obj
        when Symbol, String, TrueClass, FalseClass, NilClass, Fixnum, Bignum
          "#<#{obj.inspect}: #{inspect_instance_variables(obj, ivars, seen)}>"
        when Array
          "#<#{inspect_array(obj, seen)}: #{inspect_instance_variables(obj, ivars, seen)}>"
        when Hash
          "#<#{inspect_hash(obj, seen)}: #{inspect_instance_variables(obj, ivars, seen)}>"
        else
          "\#<#{obj.class}:0x#{(obj.__id__ << 1).to_s(16)} #{inspect_instance_variables(obj, ivars, seen)}>"
      end
    end
  end

  def self.inspect_array(array, seen)
    '['+array.map { |v| Inspector.inspect_object(v, seen) }.join(', ')+']'
  end

  def self.inspect_hash(hash, seen)
    '{'+hash.map { |k,v| Inspector.inspect_object(k, seen)+' => '+Inspector.inspect_object(v, seen) }.join(', ')+'}'
  end

  def self.inspect_instance_variables(obj, ivars, seen)
    ivars.map { |ivar|
      "#{ivar}=#{InstanceVariableGet.bind(obj).call(ivar)}"
    }.join(', ')
  end

  def self.inspect_recursion(obj)
    case obj
      when Hash then '{...}'
      when Array then '[...]'
      else "\#<#{obj.class}:0x#{(obj.__id__ << 1).to_s(16)} ...>"
    end
  end

  def inspect
    Inspector.inspect_object(self)
  end
end
