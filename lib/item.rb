# encoding: utf-8

class Item
  attr_reader :name, :description

  def initialize(name, description)
    @name         = name
    @description  = description
  end
end
