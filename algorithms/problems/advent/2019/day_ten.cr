# https://adventofcode.com/2019/day/10
#
# --- Day 10: Monitoring Station ---
#
# You fly into the asteroid belt and reach the Ceres monitoring station. The Elves here have an emergency: they're having trouble tracking all of the asteroids and can't be sure they're safe.
#
# The Elves would like to build a new monitoring station in a nearby area of space; they hand you a map of all of the asteroids in that region (your puzzle input).
#
# The map indicates whether each position is empty (.) or contains an asteroid (#). The asteroids are much smaller than they appear on the map, and every asteroid is exactly in the center of its marked position. The asteroids can be described with X,Y coordinates where X is the distance from the left edge and Y is the distance from the top edge (so the top-left corner is 0,0 and the position immediately to its right is 1,0).
#
# Your job is to figure out which asteroid would be the best place to build a new monitoring station. A monitoring station can detect any asteroid to which it has direct line of sight - that is, there cannot be another asteroid exactly between them. This line of sight can be at any angle, not just lines aligned to the grid or diagonally. The best location is the asteroid that can detect the largest number of other asteroids.
#
# For example, consider the following map:
#
# .#..#
# .....
# #####
# ....#
# ...##
#
# The best location for a new monitoring station on this map is the highlighted asteroid at 3,4 because it can detect 8 asteroids, more than any other location. (The only asteroid it cannot detect is the one at 1,0; its view of this asteroid is blocked by the asteroid at 2,2.) All other asteroids are worse locations; they can detect 7 or fewer other asteroids. Here is the number of other asteroids a monitoring station on each asteroid could detect:
#
# .7..7
# .....
# 67775
# ....7
# ...87
#
# Here is an asteroid (#) and some examples of the ways its line of sight might be blocked. If there were another asteroid at the location of a capital letter, the locations marked with the corresponding lowercase letter would be blocked and could not be detected:
#
# #.........
# ...A......
# ...B..a...
# .EDCG....a
# ..F.c.b...
# .....c....
# ..efd.c.gb
# .......c..
# ....f...c.
# ...e..d..c
#
# Here are some larger examples:
#
#     Best is 5,8 with 33 other asteroids detected:
#
#     ......#.#.
#     #..#.#....
#     ..#######.
#     .#.#.###..
#     .#..#.....
#     ..#....#.#
#     #..#....#.
#     .##.#..###
#     ##...#..#.
#     .#....####
#
#     Best is 1,2 with 35 other asteroids detected:
#
#     #.#...#.#.
#     .###....#.
#     .#....#...
#     ##.#.#.#.#
#     ....#.#.#.
#     .##..###.#
#     ..#...##..
#     ..##....##
#     ......#...
#     .####.###.
#
#     Best is 6,3 with 41 other asteroids detected:
#
#     .#..#..###
#     ####.###.#
#     ....###.#.
#     ..###.##.#
#     ##.##.#.#.
#     ....###..#
#     ..#.#..#.#
#     #..#.#.###
#     .##...##.#
#     .....#.#..
#
#     Best is 11,13 with 210 other asteroids detected:
#
#     .#..##.###...#######
#     ##.############..##.
#     .#.######.########.#
#     .###.#######.####.#.
#     #####.##.#.##.###.##
#     ..#####..#.#########
#     ####################
#     #.####....###.#.#.##
#     ##.#################
#     #####.##.###..####..
#     ..######..##.#######
#     ####.##.####...##..#
#     .#####..#.######.###
#     ##...#.##########...
#     #.##########.#######
#     .####.#.###.###.#.##
#     ....##.##.###..#####
#     .#.#.###########.###
#     #.#.#.#####.####.###
#     ###.##.####.##.#..##
#
# Find the best location for a new monitoring station. How many other asteroids can be detected from that location?

class AsteroidMap
  EMPTY_CELL    = '.'
  ASTEROID_CELL = '#'

  def initialize(@map : Array(String))
    @asteroids = [] of Tuple(Int32, Int32)
  end

  def size
    x = @map.size
    y = @map[0].size
    {x, y}
  end

  def suggestion
    cells = asteroids
    max = {0, cells[0]}
    cells.each do |cell0|
      cs = assteroids_coeficients_around(cell0)
      counts = cs.size
      if counts > max[0]
        max = {counts, cell0}
      end
    end
    return max
  end

  def assteroids_coeficients_around(cell0)
    cells = asteroids
    result = [] of Tuple(Float64, Float64, Float64)
    dict = {} of Tuple(Float64, Float64, Float64) => Array(Tuple(Int32, Int32))
    cells.each do |cell1|
      next if cell0 == cell1
      c = coefficient(cell0, cell1)
      result << c
      # if dict.has_key?(c)
      #   dict[c] << cell1
      # else
      #   dict[c] = [cell1] of Tuple(Int32, Int32)
      # end
    end
    counts = result.uniq.size
    # puts "----"
    # puts "cell: #{cell0}"
    # puts "cells:     #{cells - [cell0]}"
    # puts "coef:      #{result}"
    # puts "coef uniq: #{result.uniq}"
    # puts "counts: #{counts}"
    # puts "dict[#{dict.size}]:       #{dict}"
    # puts "dict no uniq:"
    # dict.each do |k, v|
    #   if v.size > 2
    #     puts "#{k}  => #{v}"
    #   end
    # end
    result.uniq
  end

  def coefficient(cell0, cell1)
    x0, y0 = cell0
    x1, y1 = cell1

    k = (y1 - y0) / (x1 - x0)
    # b = y0.to_f64 - k * x0

    b = (y1 - y0) > 0 ? 1_f64 : -1_f64
    d = (x1 - x0) > 0 ? 1_f64 : -1_f64

    #k0 = (x1 - x0).abs
    #k0 = 1 if k0 == 0
    #{(y1 - y0).to_f64 / k0, (x1 - x0).to_f64 / k0}
    {k, b, d}
  end

  def asteroids
    return @asteroids if @asteroids.size > 0
    @map.each_with_index do |row, x|
      row.each_char_with_index do |cell, y|
        next if cell == EMPTY_CELL
        @asteroids << {y, x}
      end
    end
    @asteroids
  end
end