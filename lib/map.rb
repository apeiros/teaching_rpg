# encoding: utf-8

require 'set'
require 'yaml'

class Map
  Position = Struct.new(:x, :y) do
    def moved(by_x, by_y)
      Position.new(x+by_x, y+by_y)
    end
  end

  Water       = ["\e[38;5;18;48;5;27m%s\e[0m",    ' '] # ≈
  Grass       = ["\e[38;5;149;48;5;118m%s\e[0m",  ' '] # ∴
  Forrest     = ["\e[38;5;100;48;5;28m%s\e[0m",   ' '] # ∴
  StoneWall   = ["\e[38;5;236;48;5;241m%s\e[0m",  ' '] # ∴
  StoneFloor  = ["\e[38;5;248;48;5;253m%s\e[0m",  ' '] # ⁙
  WoodFloor   = ["\e[38;5;248;48;5;214m%s\e[0m",  ' '] # |, =
  Player      = ["\e[38;5;124;48;5;124m%s\e[0m",  ' ']

  Parse = {
    'x'.ord => :forrest,
    '.'.ord => :grass,
    '='.ord => :wood_floor,
    '#'.ord => :stone_wall,
    ' '.ord => :stone_floor,
    '~'.ord => :water,
  }
  Render = {
    forrest:      Forrest,
    grass:        Grass,
    stone_wall:   StoneWall,
    stone_floor:  StoneFloor,
    wood_floor:   WoodFloor,
    water:        Water,
    player:       Player # 253
  }
  Walkable = [:wood_floor, :grass, :stone_floor].to_set

  def self.read_file(file)
    lines       = File.readlines(file+'.txt')
    meta        = YAML.load_file(file+'.yaml')
    new(lines.map { |line|
      line.chomp.unpack("C*").map { |chr|
        Parse[chr] || raise("Unknown char: #{chr.inspect}")
      }
    }, meta)
  end

  attr_reader :tiles, :height, :width, :player_position, :enemies, :enemy_probability

  def initialize(tiles, meta)
    @tiles              = tiles
    @meta               = meta
    @player_position    = Position.new(*meta['start'])
    @width, @height     = @tiles.first.size, @tiles.size
    @enemy_probability  = meta['enemy_probability']
    @enemies            = meta['enemies']
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

  def slice(x, y, width, height)
    y.upto(y+height-1).map { |y|
      row = @tiles.at(y)
      x.upto(x+width-1).map { |x|
        cell = row.at(x)
        cell = :player if (x == @player_position.x && y == @player_position.y)
        format, char = Render[cell]
        format % char
      }.join
    }.join("\n")
  end
end
