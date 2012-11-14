class Enemy
  attr_reader :name, :health_points, :attack, :armor

  def initialize(name, health_points, attack, armor)
    @name           = name
    @health_points  = health_points
    @attack         = attack
    @armor          = armor
  end

  def alive?
    @health_points > 0
  end
  def dead?
    !alive?
  end

  def take_physical_damage(damage)
    damage -= armor
    damage  = 0 if damage < 0
    @health_points -= damage
    @health_points  = 0 if @health_points < 0

    damage
  end

  def magic_points
    0
  end
end
