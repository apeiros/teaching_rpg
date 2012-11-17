# encoding: utf-8

class Shop
  def self.from_file(path)
    shop_name = File.basename(path, '.yaml')
    shop      = new(shop_name, YAML.load_file(path))
  end

  attr_reader :name, :description

  def initialize(name, description)
    @name         = name
    @description  = description
  end
end
