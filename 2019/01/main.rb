def calculate_fuel(mass)
  (mass / 3) - 2
end

def calculate_total_fuel(mass)
  fuel = calculate_fuel(mass)

  if fuel <= 0
    return 0
  end

  return fuel + calculate_total_fuel(fuel)
end

part1 = 0
part2 = 0

f = File.foreach("input.txt") do |line|
  mass = line.strip.to_i
  part1 += calculate_fuel(mass)
  part2 += calculate_total_fuel(mass)
end

puts "Part1: #{ part1 }"
puts "Part2: #{ part2 }"
