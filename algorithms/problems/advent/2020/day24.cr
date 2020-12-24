# https://adventofcode.com/2020/day/24
#
# --- Day 24: Lobby Layout ---

# Your raft makes it to the tropical island; it turns out that the small crab was an excellent navigator. You make your way to the resort.

# As you enter the lobby, you discover a small problem: the floor is being renovated. You can't even reach the check-in desk until they've finished installing the new tile floor.

# The tiles are all hexagonal; they need to be arranged in a hex grid with a very specific color pattern. Not in the mood to wait, you offer to help figure out the pattern.

# The tiles are all white on one side and black on the other. They start with the white side facing up. The lobby is large enough to fit whatever pattern might need to appear there.

# A member of the renovation crew gives you a list of the tiles that need to be flipped over (your puzzle input). Each line in the list identifies a single tile that needs to be flipped by giving a series of steps starting from a reference tile in the very center of the room. (Every line starts from the same reference tile.)

# Because the tiles are hexagonal, every tile has six neighbors: east, southeast, southwest, west, northwest, and northeast. These directions are given in your list, respectively, as e, se, sw, w, nw, and ne. A tile is identified by a series of these directions with no delimiters; for example, esenee identifies the tile you land on if you start at the reference tile and then move one tile east, one tile southeast, one tile northeast, and one tile east.

# Each time a tile is identified, it flips from white to black or from black to white. Tiles might be flipped more than once. For example, a line like esew flips a tile immediately adjacent to the reference tile, and a line like nwwswee flips the reference tile itself.

# Here is a larger example:

# sesenwnenenewseeswwswswwnenewsewsw
# neeenesenwnwwswnenewnwwsewnenwseswesw
# seswneswswsenwwnwse
# nwnwneseeswswnenewneswwnewseswneseene
# swweswneswnenwsewnwneneseenw
# eesenwseswswnenwswnwnwsewwnwsene
# sewnenenenesenwsewnenwwwse
# wenwwweseeeweswwwnwwe
# wsweesenenewnwwnwsenewsenwwsesesenwne
# neeswseenwwswnwswswnw
# nenwswwsewswnenenewsenwsenwnesesenew
# enewnwewneswsewnwswenweswnenwsenwsw
# sweneswneswneneenwnewenewwneswswnese
# swwesenesewenwneswnwwneseswwne
# enesenwswwswneneswsenwnewswseenwsese
# wnwnesenesenenwwnenwsewesewsesesew
# nenewswnwewswnenesenwnesewesw
# eneswnwswnwsenenwnwnwwseeswneewsenese
# neswnwewnwnwseenwseesewsenwsweewe
# wseweeenwnesenwwwswnew

# In the above example, 10 tiles are flipped once (to black), and 5 more are flipped twice (to black, then back to white). After all of these instructions have been followed, a total of 10 tiles are black.

# Go through the renovation crew's list and determine which tiles they need to flip. After all of the instructions have been followed, how many tiles are left with the black side up?

# Your puzzle answer was 332.
# --- Part Two ---

# The tile floor in the lobby is meant to be a living art exhibit. Every day, the tiles are all flipped according to the following rules:

#     Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
#     Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black.

# Here, tiles immediately adjacent means the six tiles directly touching the tile in question.

# The rules are applied simultaneously to every tile; put another way, it is first determined which tiles need to be flipped, then they are all flipped at the same time.

# In the above example, the number of black tiles that are facing up after the given number of days has passed is as follows:

# Day 1: 15
# Day 2: 12
# Day 3: 25
# Day 4: 14
# Day 5: 23
# Day 6: 28
# Day 7: 41
# Day 8: 37
# Day 9: 49
# Day 10: 37

# Day 20: 132
# Day 30: 259
# Day 40: 406
# Day 50: 566
# Day 60: 788
# Day 70: 1106
# Day 80: 1373
# Day 90: 1844
# Day 100: 2208

# After executing this process a total of 100 times, there would be 2208 black tiles facing up.

# How many tiles will be black after 100 days?

# Your puzzle answer was 3900.

alias CoordXY = {x: Int32, y: Int32}

class FloorTile
  INSTR_TO_COORD = Hash{
    "e"  => {2, 0},
    "w"  => {-2, 0},
    "ne" => {1, 1},
    "se" => {1, -1},
    "nw" => {-1, 1},
    "sw" => {-1, -1},
  }

  property color : String
  property coord : CoordXY

  def initialize(@color, @coord)
  end

  def flip!
    @color = @color == "white" ? "black" : "white"
  end

  def adjacent_coords
    result = [] of CoordXY
    INSTR_TO_COORD.each do |k, coord_diff|
      result << CoordXY.new(x: @coord[:x] + coord_diff[0], y: @coord[:y] + coord_diff[1])
    end
    result
  end
end

class FloorLayout
  property start_tile : FloorTile
  property floor_map : Hash(CoordXY, FloorTile)

  INSTR_TO_COORD = Hash{
    "e"  => {2, 0},
    "w"  => {-2, 0},
    "ne" => {1, 1},
    "se" => {1, -1},
    "nw" => {-1, 1},
    "sw" => {-1, -1},
  }

  def initialize(@start_tile, @floor_map)
  end

  def after(days)
    days.times do |i|
      flipp
    end
  end

  def flipp
    choosen_blacks = blacks
    choosen_whites = [] of FloorTile
    to_flip = [] of FloorTile
    choosen_blacks.each do |black_tile|
      blacks_count = 0
      black_tile.adjacent_coords.each do |coord|
        tile = cell(coord)
        if tile.color == "white"
          choosen_whites << tile
        else
          blacks_count += 1
        end
      end
      if blacks_count == 0 || blacks_count > 2
        to_flip << black_tile
      end
    end

    choosen_whites.uniq!
    choosen_whites.each do |white_tile|
      raise "white is not white" if white_tile.color != "white"
      blacks_count = 0
      white_tile.adjacent_coords.each do |coord|
        tile = cell(coord)
        if tile.color == "black"
          blacks_count += 1
        end
      end
      if blacks_count == 2
        to_flip << white_tile
      end
    end

    to_flip.each do |tile|
      tile.flip!
    end
  end

  def cell(coord : CoordXY)
    if !@floor_map.has_key?(coord)
      @floor_map[coord] = FloorTile.new("white", coord)
    end
    @floor_map[coord]
  end

  def self.parse(instructions) : self
    start_coord = CoordXY.new(x: 0, y: 0)
    start = FloorTile.new("white", start_coord)

    floor_map = Hash(CoordXY, FloorTile).new
    floor_map[start_coord] = start

    instructions.each do |line|
      i = 0

      node = start
      node_coord = start_coord

      next if line == ""
      instrs = line.split("")
      while i < instrs.size
        cmd = ""
        case instrs[i]
        when "s"
          cmd = instrs[i]
          if (i + 1 < instrs.size) && ["e", "w"].includes?(instrs[i + 1])
            i += 1
            cmd += instrs[i]
          end
        when "n"
          cmd = instrs[i]
          if (i + 1 < instrs.size) && ["e", "w"].includes?(instrs[i + 1])
            i += 1
            cmd += instrs[i]
          end
        when "e", "w"
          cmd = instrs[i]
        else
          raise "Unknown #{instrs[i]}"
        end
        coord_diff = INSTR_TO_COORD[cmd]
        node_coord = CoordXY.new(x: node_coord[:x] + coord_diff[0], y: node_coord[:y] + coord_diff[1])
        i += 1
      end
      if floor_map.has_key?(node_coord)
        floor_map[node_coord].flip!
      else
        floor_map[node_coord] = FloorTile.new("black", node_coord)
      end
    end

    FloorLayout.new(start, floor_map)
  end

  def blacks
    result = [] of FloorTile
    @floor_map.each do |coord, tile|
      result << tile if tile.color == "black"
    end
    result
  end

  def print
    black_count = 0
    @floor_map.each do |coord, tile|
      puts "#{coord}  => #{tile.color}"
      black_count += 1 if tile.color == "black"
    end
    puts "blacks: #{black_count}"
    puts "size: #{@floor_map.size}"
  end
end
