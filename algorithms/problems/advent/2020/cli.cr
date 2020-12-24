require "option_parser"
require "./day_one"
require "./day_two"
require "./day_three"
require "./day_four"
require "./day_five"
require "./day7"
require "./day8"
require "./day9"
require "./day10"
require "./day11"
require "./day12"
require "./day13"
require "./day14"
require "./day15"
require "./day16"
require "./day17"
require "./day18"
require "./day19"
require "./day20"
require "./day21"
require "./day22"
require "./day23"
require "./day24"
require "./day25"

def run
  exit = false
  day : Int64 = 0
  part : Int64 = 1

  OptionParser.parse do |parser|
    parser.banner = "Usage: advent [arguments]"
    parser.on("-d DAY", "--day=DAY", "Advent Day from 1 to 25. E.g: 1") { |d| day = d.to_i64 }
    parser.on("-p PART", "--part=PART", "Advent Day Part from 1 to 2. Default: 1") { |p| part = p.to_i64 }
    parser.on("-h", "--help", "Show this help") { puts parser; exit = true }

    parser.unknown_args do |before, after|
      msg = (before | after).join(" ")
    end
  end

  return if exit

  if day < 0 && day > 24
    raise "Day should be from 1 to 25"
  end

  if part != 1 && part != 2
    raise "Part should be 1 or 2"
  end

  task = day + 0.1 * part
  answer = 0
  case task
  when 0
    raise "Missing required argument: -d <DAY>"
  when 1.1
    puts "--- Day 1: Report Repair ---"
    puts "--- Part One ---"
    puts "What is the sum of the fuel requirements for all of the modules on your spacecraft?"
    entries = [] of Int64
    STDIN.each_line do |line|
      entries << line.to_i64
    end

    answer = mul_two_entries_to_sum(entries, 2020)
  when 1.2
    puts "--- Day 1: Report Repair ---"
    puts "--- Part Two ---"
    puts "In your expense report, what is the product of the three entries that sum to 2020?"
    entries = [] of Int64
    STDIN.each_line do |line|
      entries << line.to_i64
    end

    answer = mul_entries_to_sum(entries, 3, 2020)
  when 2.1
    puts "--- Day 2: Password Philosophy ---"
    puts "--- Part One ---"
    puts "How many passwords are valid according to their policies?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = Password.parse(entries).count { |pass| pass.valid? }
  when 2.2
    puts "--- Day 2: Password Philosophy ---"
    puts "--- Part Two ---"
    puts "How many passwords are valid according to the new interpretation of the policies?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = Password.parse(entries).count { |pass| pass.valid?(2) }
  when 3.1
    puts "--- Day 3: Toboggan Trajectory ---"
    puts "--- Part One ---"
    puts "Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = TobogganTrajectory.new(entries).traversing(3, 1).count('#')
  when 3.2
    puts "--- Day 3: Toboggan Trajectory ---"
    puts "--- Part Two ---"
    puts "What do you get if you multiply together the number of trees encountered on each of the listed slopes?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    trees = [] of Int64
    [
      {1.to_i64, 1.to_i64},
      {3.to_i64, 1.to_i64},
      {5.to_i64, 1.to_i64},
      {7.to_i64, 1.to_i64},
      {1.to_i64, 2.to_i64},
    ].each do |step|
      trees << TobogganTrajectory.new(entries).traversing(step[0], step[1]).count('#').to_i64
    end
    answer = trees.reduce(1.to_i64) { |a, i| a * i }
  when 4.1
    puts "--- Day 4: Passport Processing ---"
    puts "--- Part One ---"
    puts "In your batch file, how many passports are valid?"
    entries = [] of Passport
    buf = ""
    STDIN.each_line do |line|
      if line.size == 0
        entries << Passport.parse(buf)
        buf = ""
      else
        buf += " " + line
      end
    end

    if buf.size != 0
      entries << Passport.parse(buf)
    end

    entries.select! do |pass|
      pass.has_required_fields?
    end

    answer = entries.size
  when 4.2
    puts "--- Day 4: Passport Processing ---"
    puts "--- Part Two ---"
    puts "In your batch file, how many passports are valid?"
    entries = [] of Passport
    buf = ""
    STDIN.each_line do |line|
      if line.size == 0
        entries << Passport.parse(buf)
        buf = ""
      else
        buf += " " + line
      end
    end

    if buf.size != 0
      entries << Passport.parse(buf)
    end

    entries.select! do |pass|
      pass.valid?
    end

    answer = entries.size
  when 5.1
    puts "--- Day 5: Binary Boarding ---"
    puts "--- Part One ---"
    puts "What is the highest seat ID on a boarding pass?"
    entries = [] of Int64

    STDIN.each_line do |line|
      entries << BoardSeat.parse(line).seat_id
    end

    answer = entries.max
  when 5.2
    puts "--- Day 5: Binary Boarding ---"
    puts "--- Part Two ---"
    puts "What is the ID of your seat?"
    entries = [] of Int64

    STDIN.each_line do |line|
      entries << BoardSeat.parse(line).seat_id
    end

    entries.sort!
    i = 0
    prev = entries[0]
    answer = prev
    while i < entries.size
      i += 1
      cur = entries[i]
      if cur - prev > 1
        answer = cur - 1
        break
      end
      prev = cur
    end
  when 6.1
    puts "--- Day 6: Custom Customs ---"
    puts "--- Part One ---"
    puts "What is the sum of those counts?"
    answer = 0
    buf = ""
    STDIN.each_line do |line|
      if line.size == 0
        answer += buf.chars.uniq.size
        buf = ""
      else
        buf += line
      end
    end
    if buf.size != 0
      answer += buf.chars.uniq.size
    end
  when 6.2
    puts "--- Day 6: Custom Customs ---"
    puts "--- Part Two ---"
    puts "What is the sum of those counts?"
    answer = 0
    entries = [] of String
    buf = ""
    STDIN.each_line do |line|
      if line.size == 0
        answer += buf.strip.split(" ").map { |a| a.chars.sort.uniq }.reduce { |a, i| a & i }.size
        buf = ""
      else
        buf += " " + line
      end
    end
    if buf.size != 0
      answer += buf.strip.split(" ").map { |a| a.chars.sort.uniq }.reduce { |a, i| a & i }.size
    end
  when 7.1
    puts "--- Day 7: Handy Haversacks ---"
    puts "--- Part One ---"
    puts "How many bag colors can eventually contain at least one shiny gold bag? "
    answer = 0
    bags = Hash(String, Array(String)).new
    reverse_bags = Hash(String, Array(String)).new
    STDIN.each_line do |line|
      bag = line.gsub(" contain no other bags.", "")
        .gsub("bags", "bag").gsub("contain", "")
        .gsub("  ", " ")
        .gsub(".", "")
        .gsub(",", "").split(" bag")
      clean_bags = Array(String).new
      bag[1..-2].each do |b|
        clean_bag = b.gsub(/^ \d* /, "")
        clean_bags << clean_bag
        reverse_bags[clean_bag] ||= Array(String).new
        reverse_bags[clean_bag] << bag[0]
      end
      bags[bag[0]] = clean_bags
    end

    bags_with_shiny_gold = Hash(String, Bool).new

    queue = reverse_bags["shiny gold"]
    bags_with_shiny_gold["shiny gold"] = true
    while queue.size > 0
      new_queue = Array(String).new
      queue.each do |with_gold_bag|
        bags_with_shiny_gold[with_gold_bag] = true
        new_queue += reverse_bags[with_gold_bag] if reverse_bags.has_key?(with_gold_bag)
      end
      queue = new_queue
    end

    answer = 0
    bags.keys.each do |bag|
      if bags_with_shiny_gold.has_key?(bag) && bag != "shiny gold"
        answer += 1
      end
    end
  when 7.2
    puts "--- Day 7: Handy Haversacks ---"
    puts "--- Part Two ---"
    puts "How many individual bags are required inside your single shiny gold bag?"
    answer = 0
    bags = Hash(String, Array(String)).new
    STDIN.each_line do |line|
      bag = line.gsub(" contain no other bags.", "")
        .gsub("bags", "bag").gsub("contain", "")
        .gsub("  ", " ")
        .gsub(".", "")
        .gsub(",", "").split(" bag")
      bags[bag[0]] = bag[1..-2]
    end

    answer = count_bags("shiny gold", bags)
  when 8.1
    puts "--- Day 8: Handheld Halting ---"
    puts "--- Part One ---"
    puts "what value is in the accumulator?"
    code = [] of GameboyCommand

    STDIN.each_line do |line|
      code << GameboyCommand.parse(line)
    end

    console = Gameboy.new(code)
    console.detect_loop
    answer = console.accumulator
  when 8.2
    puts "--- Day 8: Handheld Halting ---"
    puts "--- Part Two ---"
    puts "What is the value of the accumulator after the program terminates?"
    code = [] of GameboyCommand

    STDIN.each_line do |line|
      code << GameboyCommand.parse(line)
    end

    answer = 0.to_i64
    console = Gameboy.new(code)
    history = console.detect_loop
    steps = 0
    history.reverse.each do |cmd_id|
      steps += 1
      new_code = code.dup
      new_code[cmd_id] = new_code[cmd_id].swap
      console = Gameboy.new(new_code)
      console.detect_loop
      if console.end?
        answer = console.accumulator
        break
      end
    end

    puts "(detected in #{steps} steps)"
  when 9.1
    puts "--- Day 9: Encoding Error ---"
    puts "--- Part One ---"
    puts "wWhat is the first number that does not have this property?"
    input = [] of Int64

    STDIN.each_line do |line|
      input << line.to_i64
    end

    answer = weak_number(input, 25.to_i64)
  when 9.2
    puts "--- Day 9: Encoding Error ---"
    puts "--- Part Two ---"
    puts "What is the encryption weakness in your XMAS-encrypted list of numbers?"
    input = [] of Int64

    STDIN.each_line do |line|
      input << line.to_i64
    end

    n = weak_number_index(input, 25.to_i64)
    if n.nil?
      puts "Could not find index woth weak number in array"
      return
    end
    broken = input[n]
    answer = hash_largest_contiguous_numbers(input[0..n], broken.not_nil!)
  when 10.1
    puts "--- Day 10: Adapter Array ---"
    puts "--- Part One ---"
    puts "What is the number of 1-jolt differences multiplied by the number of 3-jolt differences?"
    input = [] of Int64

    STDIN.each_line do |line|
      input << line.to_i64
    end

    r = distributions(input.sort)
    answer = r[1] * r[3]
  when 10.2
    puts "--- Day 10: Adapter Array ---"
    puts "--- Part Two ---"
    puts "What is the total number of distinct ways you can arrange the adapters to connect the charging outlet to your device?"
    input = [] of Int64

    STDIN.each_line do |line|
      input << line.to_i64
    end

    devices = [0.to_i64] + input.sort
    device = 3.to_i64

    answer = combinations(devices, Hash(Array(Int64), Int64).new)
  when 11.1
    puts "--- Day 11: Seating System ---"
    puts "--- Part One ---"
    puts "how many seats end up occupied?"
    seats = [] of Array(Char)

    STDIN.each_line do |line|
      seats << line.chars
    end

    answer = SeatingSystem.new(seats).stabalize_rounds
  when 11.2
    puts "--- Day 11: Seating System ---"
    puts "--- Part Two ---"
    puts "how many seats end up occupied?"
    seats = [] of Array(Char)

    STDIN.each_line do |line|
      seats << line.chars
    end

    answer = SeatingSystem.new(seats).stabalize_rounds('2')
  when 12.1
    puts "--- Day 12: Rain Risk ---"
    puts "--- Part One ---"
    puts "What is the Manhattan distance between that location and the ship's starting position?"
    commands = [] of String

    STDIN.each_line do |line|
      commands << line
    end

    answer = rain_risk(commands)
  when 12.2
    puts "--- Day 12: Rain Risk ---"
    puts "--- Part Two ---"
    puts "What is the Manhattan distance between that location and the ship's starting position?"
    commands = [] of String

    STDIN.each_line do |line|
      commands << line
    end

    answer = rain_risk2(commands)
  when 13.1
    puts "--- Day 13: Shuttle Search ---"
    puts "--- Part One ---"
    puts "What is the ID of the earliest bus you can take to the airport multiplied by the number of minutes you'll need to wait for that bus?"
    commands = [] of String

    STDIN.each_line do |line|
      commands << line
    end

    answer = earliest_bus(commands[0], commands[1])
  when 13.2
    puts "--- Day 13: Shuttle Search ---"
    puts "--- Part Two ---"
    puts "What is the earliest timestamp such that all of the listed bus IDs depart at offsets matching their positions in the list?"
    commands = [] of String

    STDIN.each_line do |line|
      commands << line
    end

    answer = earliest_bus2(commands[1])
  when 14.1
    puts "--- Day 14: Docking Data ---"
    puts "--- Part One ---"
    puts "What is the sum of all values left in memory after it completes?"
    commands = [] of String

    STDIN.each_line do |line|
      commands << line
    end

    answer = DockingData.parse(commands).sum
  when 14.2
    puts "--- Day 14: Docking Data ---"
    puts "--- Part Two ---"
    puts "What is the sum of all values left in memory after it completes?"
    commands = [] of String

    STDIN.each_line do |line|
      commands << line
    end

    answer = DockingData.parse(commands, 2).sum
  when 15.1
    puts "--- Day 15: Rambunctious Recitation ---"
    puts "--- Part One ---"
    puts "Given your starting numbers, what will be the 2020th number spoken?"
    numbers = Array(Array(Int64)).new

    STDIN.each_line do |line|
      numbers << line.split(',').map(&.to_i64)
    end

    answer = MemoryGame.new(numbers[0]).spoken(2020)
  when 15.2
    puts "--- Day 15: Rambunctious Recitation ---"
    puts "--- Part Two ---"
    puts "Given your starting numbers, what will be the 30000000th number spoken?"
    numbers = Array(Array(Int64)).new

    STDIN.each_line do |line|
      numbers << line.split(',').map(&.to_i64)
    end

    answer = MemoryGame.new(numbers[0]).spoken(30000000)
  when 16.1
    puts "--- Day 16: Ticket Translation ---"
    puts "--- Part One ---"
    puts "What is your ticket scanning error rate?"
    tickets = Array(String).new

    STDIN.each_line do |line|
      tickets << line
    end

    answer = TicketTranslation.parse(tickets).error_rate
  when 16.2
    puts "--- Day 16: Ticket Translation ---"
    puts "--- Part Two ---"
    puts "What do you get if you multiply those six values together?"
    tickets = Array(String).new

    STDIN.each_line do |line|
      tickets << line
    end

    answer = TicketTranslation.parse(tickets).departure_mul
  when 17.1
    puts "--- Day 17: Conway Cubes ---"
    puts "--- Part One ---"
    puts "How many cubes are left in the active state after the sixth cycle?"
    tickets = Array(String).new

    STDIN.each_line do |line|
      tickets << line
    end

    subject = ConwayCubes.parse(tickets)
    6.times do
      subject.cycle
    end

    answer = subject.active
  when 17.2
    puts "--- Day 17: Conway Cubes ---"
    puts "--- Part Two ---"
    puts "How many cubes are left in the active state after the sixth cycle?"
    tickets = Array(String).new

    STDIN.each_line do |line|
      tickets << line
    end

    subject = ConwayCubes2.parse(tickets)
    subject.print

    6.times do
      subject.cycle
    end

    answer = subject.active
  when 18.1
    puts "--- Day 17: Conway Cubes ---"
    puts "--- Part One ---"
    puts "How many cubes are left in the active state after the sixth cycle?"
    exps = Array(String).new

    STDIN.each_line do |line|
      exps << line
    end

    answer = Calculator.sum(exps)
  when 18.2
    puts "--- Day 17: Conway Cubes ---"
    puts "--- Part Two ---"
    puts "How many cubes are left in the active state after the sixth cycle?"
    exps = Array(String).new

    STDIN.each_line do |line|
      exps << line
    end

    answer = Calculator2.sum(exps)
  when 19.1
    puts "--- Day 19: Monster Messages ---"
    puts "--- Part One ---"
    puts "How many messages completely match rule 0?"
    messages = Array(String).new

    STDIN.each_line do |line|
      messages << line
    end

    answer = SimpleRegexp.validate(messages)
  when 19.2
    puts "--- Day 19: Monster Messages ---"
    puts "--- Part Two ---"
    puts "After updating rules 8 and 11, how many messages completely match rule 0?"
    messages = Array(String).new

    STDIN.each_line do |line|
      messages << line
    end

    answer = SimpleRegexp.validate(messages, version = 2)
  when 20.1
    puts "--- Day 20: Jurassic Jigsaw ---"
    puts "--- Part One ---"
    puts "What do you get if you multiply together the IDs of the four corner tiles?"
    messages = Array(String).new

    STDIN.each_line do |line|
      messages << line
    end

    images = Tile.parse(messages)
    square = Tile.assemble(images)
    answer = square[0][0].id.to_i64 * square[0][-1].id.to_i64 * square[-1][-1].id.to_i64 * square[-1][0].id.to_i64
  when 20.2
    puts "--- Day 20: Jurassic Jigsaw ---"
    puts "--- Part Two ---"
    puts "How many # are not part of a sea monster?"
    messages = Array(String).new

    STDIN.each_line do |line|
      messages << line
    end

    images = Tile.parse(messages)
    answer = Tile.detect_monster(images)
  when 21.1
    puts "--- Day 21: Allergen Assessment ---"
    puts "--- Part One ---"
    puts "How many times do any of those ingredients appear?"
    messages = Array(String).new

    STDIN.each_line do |line|
      messages << line
    end

    subject = AllergenDetector.parse(messages)
    answer = subject.ingredients_without_allergens
  when 21.2
    puts "--- Day 21: Allergen Assessment ---"
    puts "--- Part Two ---"
    puts "What is your canonical dangerous ingredient list?"
    messages = Array(String).new

    STDIN.each_line do |line|
      messages << line
    end

    subject = AllergenDetector.parse(messages)
    answer = subject.ingredients_list
  when 22.1
    puts "--- Day 22: Crab Combat ---"
    puts "--- Part One ---"
    puts "What is the winning player's score?"
    messages = Array(String).new

    STDIN.each_line do |line|
      messages << line
    end

    subject = SpaceCardsGame.parse(messages)
    answer = subject.play.score
  when 22.2
    puts "--- Day 22: Crab Combat ---"
    puts "--- Part Two ---"
    puts "What is the winning player's score?"
    messages = Array(String).new

    STDIN.each_line do |line|
      messages << line
    end

    subject = SpaceCardsGame.parse(messages)
    answer = subject.play2.score
  when 23.1
    puts "--- Day 23: Crab Cups ---"
    puts "--- Part One ---"
    puts "What are the labels on the cups after cup 1?"
    messages = Array(String).new

    STDIN.each_line do |line|
      messages << line
    end

    game = CupGame.parse(messages[0], messages.size)
    game.play(100)
    answer = game.result
  when 23.2
    puts "--- Day 23: Crab Cups ---"
    puts "--- Part Two ---"
    puts "What do you get if you multiply their labels together?"
    messages = Array(String).new

    STDIN.each_line do |line|
      messages << line
    end

    game = CupGame.parse(messages[0], 1000000)
    game.play(10000000)
    answer = game.found_star
  when 24.1
    puts "--- Day 24: Lobby Layout ---"
    puts "--- Part One ---"
    puts "How many tiles are left with the black side up?"
    instructions = Array(String).new

    STDIN.each_line do |line|
      instructions << line
    end

    floor = FloorLayout.parse(instructions)
    answer = floor.blacks.size
  when 24.2
    puts "--- Day 24: Lobby Layout ---"
    puts "--- Part Two ---"
    puts "How many tiles will be black after 100 days?"
    instructions = Array(String).new

    STDIN.each_line do |line|
      instructions << line
    end

    floor = FloorLayout.parse(instructions)
    floor.after(100)
    answer = floor.blacks.size
  else
    raise "Day is not implemented"
  end
  puts "Answer: #{answer}"
end

elapsed_time = Time.measure do
  run()
end
puts "(execute time: #{elapsed_time})"
