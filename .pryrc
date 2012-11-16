# encoding: utf-8

$LOAD_PATH << File.expand_path('lib')

require 'game'

Enemies.load_all
H = Hero.new('Alderan')
E = Enemies.all.spawn('Wabbit')
