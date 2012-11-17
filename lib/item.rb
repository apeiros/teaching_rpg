# encoding: utf-8

class Item
  attr_reader :name, :description, :action

  def initialize(name, description)
    @name         = name
    @description  = description
    @action       = nil
  end

  def size
    1
  end
end
