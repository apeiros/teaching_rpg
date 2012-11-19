# encoding: utf-8

class ShopItem
  attr_reader :type, :name, :max_quantity, :price, :description, :item
  attr_accessor :quantity

  def initialize(name, quantity, price)
    @item         = Game.items[name]
    @name         = name
    @quantity     = quantity
    @max_quantity = quantity
    @price        = price
    @description  = @item.description
    @type         = @item.display_type
  end
end
