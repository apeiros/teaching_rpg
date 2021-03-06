# encoding: utf-8

require 'shopitem'

class Shop
  def self.load_all
    shops = {}
    Dir.glob('data/shops/**/*.yaml') do |file|
      shop = Shop.from_file(file)
      shops[shop.name] = shop
    end

    shops
  end

  def self.from_file(path)
    shop_name = File.basename(path, '.yaml')
    shop      = new(shop_name, YAML.load_file(path))
  end

  attr_reader :name, :items

  def initialize(name, description)
    @name   = name
    @items  = description['items'].map { |name, (amount, price)|
      ShopItem.new(name, amount, price)
    }
  end
end
