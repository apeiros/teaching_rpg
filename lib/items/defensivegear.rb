# encoding: utf-8

require 'item'

module Items
  class DefensiveGear < Item
    attr_reader :armor

    def initialize(name, attributes)
      super(name, attributes.merge(description: "Improves your defense and reduces damage taken by %{armor} health points"))
    end

    def apply(entity)
      old_item      = entity.send(@type)
      entity.send(:"#{@type}=", self)
      entity.backpack.add(old_item) if old_item
      @action = "Equipped #{entity.name} with #{@name}"
    end
  end
end
