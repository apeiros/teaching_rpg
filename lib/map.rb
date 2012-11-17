# encoding: utf-8

require 'set'
require 'yaml'
require 'point'
require 'rectangle'

class Map
  Parse   = {}
  Render  = {}

  def self.tile(name, map_char, fg, bg, bold, render_char)
    Parse[map_char.ord] = name
    Render[name]        = ["\e[38;5;#{fg};48;5;#{bg}#{bold ? ';1' : ''}m%s", render_char]
  end
  def self.tiles(definition)
    definition.each do |name, values|
      tile(name, *values)
    end
  end

  tiles(
    forrest:      ['x', 100,  28,   false, ' '], # ∴
    grass:        ['.', 149,  118,  false, ' '], # ∴
    track:        ['|', 142,  142,  false, ' '], # ∴
    stone_wall:   ['#', 236,  241,  false, ' '], # ⁙
    stone_floor:  [' ', 248,  253,  false, ' '], # | =
    wood_floor:   ['=', 248,  214,  false, ' '], # ∴
    water:        ['~',  18,   27,  false, ' '], # ≈
    roof:         ['A',  88,  124,  false, 'A'],
    house:        ['H',  16,  172,  false, ' '],
    door:         ['?',  16,   16,  false, ' '],

    player:       ['P', 124,  124,  false, ' '], # 253
    boss:         ['B', 196,   16,  true,  '?'],
  )
  Walkable = [:wood_floor, :grass, :stone_floor, :door, :track].to_set

  def self.read_file(game, file)
    name  = File.basename(file)
    lines = File.readlines(file+'.txt')
    meta  = YAML.load_file(file+'.yaml')
    tiles = lines.map { |line|
      line.chomp.unpack("C*").map { |chr|
        Parse[chr] || raise("Unknown char: #{chr.inspect}")
      }
    }
    new(game, name, tiles, meta)
  end

  attr_reader   :tiles, :height, :width, :player, :enemies, :enemy_probability, :meta
  attr_accessor :screen_width, :screen_height, :clipping, :name
  attr_reader   :connections

  def initialize(game, name, tiles, meta)
    @game               = game
    @name               = name
    @tiles              = tiles
    @meta               = meta
    @player             = Point.new(*meta['start_position'])
    @width              = @tiles.first.size
    @height             = @tiles.size
    @size               = Rectangle.new(0, 0, @width, @height)
    @enemy_probability  = meta['enemy_probability']
    @enemies            = meta['enemies']
    @screen_width       = 120
    @screen_height      = 38
    @points_of_interest = meta['points_of_interest']
    @connections        = {}
    @points_of_interest.each do |(x,y),(type, *args)|
      if type == 'connection'
        @connections[args] = [x,y]
      end
    end
    auto_clip

    raise "Invalid map" unless @tiles.all? { |row| row.size == @width }
  end

  def point_of_interest?(position=@player)
    !!point_of_interest(position)
  end

  def point_of_interest(position=@player)
    poi = @points_of_interest[position.to_a]
    if poi && poi[0] == 'boss'
      poi = nil if @game.defeated?(@name, position)
    end

    poi
  end

  def move_to_connection(map_name, connection_number)
    @player = Point.new(*@connections[[map_name, connection_number]])
    auto_clip
  end

  def auto_clip
    x = @player.x - @screen_width/2
    y = @player.y - @screen_height/2
    x = 0 if x < 0
    y = 0 if y < 0
    x = @width-@screen_width    if x > @width-@screen_width
    y = @height-@screen_height  if y > @height-@screen_height

    set_clipping(x, y)
  end

  def set_clipping(x, y)
    @clipping = Rectangle.new(x, y, @screen_width, @screen_height)
  end

  def relative_position
    @player.relative_to(@clipping)
  end

  def move_up
    moved = @player.up
    @player = moved if valid_position?(moved)
  end
  def move_down
    moved = @player.down
    @player = moved if valid_position?(moved)
  end
  def move_left
    moved = @player.left
    @player = moved if valid_position?(moved)
  end
  def move_right
    moved = @player.right
    @player = moved if valid_position?(moved)
  end

  def valid_position?(point)
    point.within?(@size) && Walkable.include?(@tiles[point.y][point.x])
  end

  def rendered_slice
    @clipping.each_y.map { |y|
      row = @tiles.at(y)
      @clipping.each_x.map { |x|
        poi  = point_of_interest([x,y])
        cell = row.at(x)

        if @player.at?(x, y)
          format, char = Render[:player]
        elsif poi && poi[0] == 'boss'
          format, char = Render[:boss]
        else
          format, char = Render[cell]
        end

        format % char
      }.join
    }.join("\n")
  end
end
