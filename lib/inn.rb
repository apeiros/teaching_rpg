# encoding: utf-8

# represents an Inn, where the hero can sleep and regenerate
class Inn
  def self.load_all
    Hash[YAML.load_file('data/inns.yaml').map { |name, cost_per_night|
      [name, Inn.new(cost_per_night)]
    }]
  end

  def initialize(cost_per_night)
    @cost_per_night = cost_per_night
  end
end
