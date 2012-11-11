# encoding: utf-8

require 'set'

class Map
  Position = Struct.new(:x, :y) do
    def moved(by_x, by_y)
      Position.new(x+by_x, y+by_y)
    end
  end

  Water       = ["\e[38;5;18;48;5;27m%s\e[0m",    '≈']
  Grass       = ["\e[38;5;149;48;5;118m%s\e[0m",  '∴']
  Forrest     = ["\e[38;5;100;48;5;28m%s\e[0m",   '∴']
  StoneWall   = ["\e[38;5;236;48;5;241m%s\e[0m",  '∴']
  StoneFloor  = ["\e[38;5;248;48;5;253m%s\e[0m",  '⁙']
  Player      = ["\e[38;5;124;48;5;124m%s\e[0m",  ' ']

  Parse = {
    'x'.ord => :forrest,
    '.'.ord => :grass,
    '#'.ord => :stone_wall,
    ' '.ord => :stone_floor,
    '~'.ord => :water,
  }
  Render = {
    forrest:      Forrest,
    grass:        Grass,
    stone_wall:   StoneWall,
    stone_floor:  StoneFloor,
    water:        Water,
    player:       Player # 253
  }
  Walkable = [:grass, :stone_floor].to_set

  def self.read_file(file)
    lines       = File.readlines(file)
    meta        = lines.shift
    position    = Position.new(*meta.match(/^start:(\d+),(\d+)/).captures.map(&:to_i))
    new(lines.map { |line|
      line.chomp.unpack("C*").map { |chr|
        Parse[chr] || raise("Unknown char: #{chr.inspect}")
      }
    }, position)
  end

  attr_reader :tiles, :height, :width, :player_position

  def initialize(map, player_position)
    @tiles            = map
    @player_position  = player_position
    @width, @height   = @tiles.first.size, @tiles.size
  end

  def move_up
    @player_position.y -= 1 if @player_position.y > 0 && valid_position?(@player_position.x, @player_position.y-1)
  end
  def move_down
    @player_position.y += 1 if @player_position.y < @height-1 && valid_position?(@player_position.x, @player_position.y+1)
  end
  def move_left
    @player_position.x -= 1 if @player_position.x > 0 && valid_position?(@player_position.x-1, @player_position.y)
  end
  def move_right
    @player_position.x += 1 if @player_position.x < @width-1 && valid_position?(@player_position.x+1, @player_position.y)
  end

  def valid_position?(x, y)
    Walkable.include?(@tiles[y][x])
  end

  def rendered
    @tiles.map.with_index { |row, y|
      row.map.with_index { |cell, x|
        cell = :player if (x == @player_position.x && y == @player_position.y)
        format, char = Render[cell]
        format % char
      }.join
    }.join("\n")
  end
end
