require_relative "./computer"

input = File.read("input.txt").strip.split(",").map(&:to_i)
c = Computer.new(input)

c.eval

puts "Part1: #{ c.output }"
