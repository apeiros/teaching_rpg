# encoding: utf-8

require 'scene'

module Scenes
  class Battle < Scene

    def initialize(game, map)
      super(game)
      @map        = map
      @hero       = @game.hero
      @retreated  = false
      pick_enemy
      @screen = Screens::Battle.new(@hero, @enemy)
      flush_input
    end

    def run
      super
      if @retreated
        restaff_enemy
      elsif @enemy.alive?
        @screen.report "#{@enemy.name} has killed you. Game over"
      else
        @screen.report "#{@enemy.name} died. Congratulations, you win!"
        @screen.draw
        lvl  = @hero.level
        loot = @hero.loot(@enemy)
        lup  = @hero.level > lvl
        sleep 0.3
        @screen.report "#{@enemy.name} dropped #{loot.gold} gold, you gained #{loot.experience} experience."
        @screen.draw
        if lup
          sleep 0.3
          @screen.report "LEVEL UP! You are now #{@hero.level}"
          @screen.draw
        end
      end
      @screen.report("Press space to continue")
      @screen.draw
      get_space
    end

    def use_item
      scene = Scenes::SelectItem.run(@game)
      if scene.action
        @screen.report scene.action
        true
      else
        false
      end
    end

    def main
      @screen.draw
      @hero.blocking = false
      begin
        result = expect_input 'a' => :attack,
                              'r' => :retreat,
                              'b' => :block,
                              'i' => :use_item,
                              'q' => :quit
      end until result || @exit
      @exit = @exit || @hero.dead? || @enemy.dead?
      unless @exit || @retreated || @enemy.dead?
        @screen.draw
        sleep 0.5
        damage_dealt = @hero.take_physical_damage @enemy.attack
        @screen.report "#{@enemy.name} attacks you and deals #{damage_dealt} damage"
      end
    end

    def attack
      damage_dealt = @enemy.take_physical_damage @hero.attack
      @screen.report "You attack #{@enemy.name} and deal #{damage_dealt} damage"
      true
    end

    def block
      @screen.report "You are assuming a defensive position"
      @hero.blocking = true
      true
    end

    def retreat
      if rand < 0.35
        @screen.report "You successfully retreated"
        @retreated  = true
        @exit       = true
      else
        @screen.report "You tried to retreat, but failed"
      end
      true
    end

    def pick_enemy
      enemy_name  = @map.enemies.keys.sample
      @enemy      = @game.enemies.spawn(enemy_name)
      @map.enemies[@enemy.name] -= 1
      @map.enemies.delete(@enemy.name) if @map.enemies[@enemy.name] == 0
    end

    def restaff_enemy
      if @map.enemies[@enemy.name]
        @map.enemies[@enemy.name] += 1
      else
        @map.enemies[@enemy.name] = 1
      end
    end
  end
end

__END__
  @screen.report "You have initiative"
