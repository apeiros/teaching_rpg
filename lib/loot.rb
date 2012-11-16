# encoding: utf-8

class Loot
  attr_reader :experience, :gold, :items

  def initialize(experience, gold, items)
    @experience  = experience
    @gold        = gold
    @items       = items
  end
end