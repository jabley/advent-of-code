input = File.read("input.txt").strip.each_char.map(&:to_i)

WIDTH  = 25
HEIGHT = 6

layers = input.each_slice(WIDTH*HEIGHT)

layers.min_by {|layer| layer.count(0) }
  .tap { |layer| puts "Part1: #{ layer.count(1) * layer.count(2) }" }
