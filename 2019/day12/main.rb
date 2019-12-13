require_relative "./simulation"

input = File.read("input.txt")
system = System.parse(input.strip)

1000.times { system.step }

puts "Part1: #{ system.total_energy }"
