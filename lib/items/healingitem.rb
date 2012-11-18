# encoding: utf-8

require 'item'

module Items
  class HealingItem < Item
    def initialize(name, attributes)
      super(name, attributes.merge(description: "Heals %{amount} health points"))
    end

    def apply(entity)
      entity.heal(@amount)
      @action = "Healed #{entity.name} for #{@amount} health points"
    end
  end
end
