# encoding: utf-8

require 'items/defensivegear'
require 'items/healingitem'

module Items
  def self.load_all
    items = {}

    Dir.glob('data/items/**/*.yaml') do |file|
      data      = YAML.load_file(file)
      defaults  = data['defaults']
      data['items'].each do |name, attributes|
        attributes  = defaults.merge(attributes)
        klass       = Object.deep_const_get(attributes.delete('class'))
        items[name] = klass.new(name, attributes)
      end
    end

    items
  end
end
