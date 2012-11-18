# encoding: utf-8

class Item
  attr_reader :name, :description, :action, :size

  def initialize(name, attributes)
    attributes    = Hash[attributes.map { |k,v| [k.to_sym, v] }]

    @name         = name
    @action       = nil
    @description  = attributes[:description] ? (attributes.delete(:description) % attributes) : name
    @size         = 1
    extract_ivars(attributes)
  end
end
