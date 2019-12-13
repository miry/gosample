# https://adventofcode.com/2019/day/13
#
# --- Day 13: Care Package ---
#
# As you ponder the solitude of space and the ever-increasing three-hour roundtrip for messages between you and Earth, you notice that the Space Mail Indicator Light is blinking. To help keep you sane, the Elves have sent you a care package.
#
# It's a new game for the ship's arcade cabinet! Unfortunately, the arcade is all the way on the other end of the ship. Surely, it won't be hard to build your own - the care package even comes with schematics.
#
# The arcade cabinet runs Intcode software like the game the Elves sent (your puzzle input).
# It has a primitive screen capable of drawing square tiles on a grid.
# The software draws tiles to the screen with output instructions:
# every three output instructions specify the x position (distance from the left),
# y position (distance from the top), and tile id. The tile id is interpreted as follows:
#
#     0 is an empty tile. No game object appears in this tile.
#     1 is a wall tile. Walls are indestructible barriers.
#     2 is a block tile. Blocks can be broken by the ball.
#     3 is a horizontal paddle tile. The paddle is indestructible.
#     4 is a ball tile. The ball moves diagonally and bounces off objects.
#
# For example, a sequence of output values like 1,2,3,6,5,4 would draw
# a horizontal paddle tile (1 tile from the left and 2 tiles from the top)
# and a ball tile (6 tiles from the left and 5 tiles from the top).
#
# Start the game. How many block tiles are on the screen when the game exits?
#
# --- Part Two ---
#
# The game didn't run because you didn't put in any quarters. Unfortunately, you did not bring any quarters.
# Memory address 0 represents the number of quarters that have been inserted; set it to 2 to play for free.
#
# The arcade cabinet has a joystick that can move left and right.
# The software reads the position of the joystick with input instructions:
#
#     If the joystick is in the neutral position, provide 0.
#     If the joystick is tilted to the left, provide -1.
#     If the joystick is tilted to the right, provide 1.
#
# The arcade cabinet also has a segment display capable of showing a single number that represents the player's current score.
# When three output instructions specify X=-1, Y=0, the third output instruction is not a tile;
# the value instead specifies the new score to show in the segment display. For example, a sequence of output values like -1,0,12345 would show 12345 as the player's current score.
#
# Beat the game by breaking all the blocks. What is your score after the last block is broken?

require "./day_nine"

alias GameProcessor = Boost

class ArcadeGame
  BLOCK_TILE = 2

  getter score : Int64
  @paddle : Tuple(Int64, Int64)
  @ball : Tuple(Int64, Int64)

  def initialize(@robot : GameProcessor)
    @tiles = {} of Tuple(Int32, Int32) => Int64
    @blocks = [] of Array(Int64)
    @score = 0
    @paddle = {0_i64, 0_i64}
    @ball = {0_i64, 0_i64}
  end

  def build
    while true
      @robot.perform
      process_state
    end
  rescue Boost::Halt
    process_state
  end

  def move_joystick
    if @paddle[0] != 0
      @robot.input << (@ball[0] <=> @paddle[0]).to_i64
    else
      @robot.input << 0
    end
  end

  def process_state
    j = 0
    buffer = Array(Int64).new(3, 0)
    @robot.output.size.times do |i|
      buffer[j] = @robot.output.delete_at(0)
      j += 1
      if j == 3
        if buffer[0] == -1
          @score = buffer[2]
        else
          case buffer[2]
          when 3
            @paddle = {buffer[0], buffer[1]}
          when 4
            @ball = {buffer[0], buffer[1]}
            move_joystick
          else
          end
        end
        j = 0
        @blocks << buffer
        buffer = Array(Int64).new(3, 0)
      end
    end
  end

  def block_titles
    @blocks.select { |i| i[2] == BLOCK_TILE }
  end

  def print
    pixels = Array(Array(Char)).new(@max_x - @min_x + 1, Array(Char).new)
    pixels.size.times do |i|
      pixels[i] = Array(Char).new(@max_y - @min_y + 1, '.')
    end

    @paints.each do |k, v|
      x, y = k[0] - @min_x, k[1] - @min_y
      pixels[x][y] = v == WHITE_COLOR ? '#' : '.'
    end

    pixels.each do |row|
      row.each do |pixel|
        print pixel
      end
      puts
    end
  end
end
