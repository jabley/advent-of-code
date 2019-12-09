require_relative "./computer"

input = File.read("input.txt").strip.split(",").map(&:to_i)

c = Computer.new(input, input: [1], debug: false)
c.eval

puts "Part1: #{ c.output.last }"

c = Computer.new(input, input: [2], debug: false)
c.eval

puts "Part2: #{ c.output.last }"
