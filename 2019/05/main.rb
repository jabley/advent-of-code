require_relative "../02/computer"

input = File.read(File.expand_path("../input.txt", __FILE__))
c = Computer.new(input, inputs: [1])

c.eval

puts "Part1: #{ c.outputs.last }"

c = Computer.new(input, inputs: [5])

c.eval

puts "Part2: #{ c.outputs.first }"
