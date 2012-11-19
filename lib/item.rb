# encoding: utf-8

class Item
  attr_reader :name, :description, :display_type, :action, :size

  def initialize(name, attributes)
    attributes    = Hash[attributes.map { |k,v| [k.to_sym, v] }]

    @name         = name
    @action       = nil
    @description  = attributes[:description] ? (attributes.delete(:description) % attributes) : name
    @size         = 1
    @display_type = "Item"
    extract_ivars(attributes)
  end
end
