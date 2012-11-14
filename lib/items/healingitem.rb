# encoding: utf-8

require 'item'

class Items
  class HealingItem < Item
    def initialize(name, amount)
      super(name, "Heals #{amount} health points")
      @amount = amount
    end

    def apply(entity)
      entity.heal(@amount)
      @action = "Healed #{entity.name} for #{@amount} health points"
    end
  end
end
