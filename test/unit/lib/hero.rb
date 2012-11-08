# encoding: utf-8

require 'hero'

suite "Hero" do
  test "Hero.new" do
    hero = Hero.new("Alderan")
    assert_equal "Alderan", hero.name
  end
end
