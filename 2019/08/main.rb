input = File.read("input.txt").strip.each_char.map(&:to_i)

WIDTH  = 25
HEIGHT = 6

layers = input.each_slice(WIDTH*HEIGHT)

layers.min_by {|layer| layer.count(0) }
  .tap { |layer| puts "Part1: #{ layer.count(1) * layer.count(2) }" }

BLACK = 0
WHITE = 1
TRANSPARENT = 2

def stack_pixels(a, b)
  a == TRANSPARENT ? b : a
end

image = layers
  .to_a
  .transpose
  .map { |pixel| pixel.reduce(&method(:stack_pixels)) }

puts "Part2:"
puts image
  .each_slice(WIDTH)
  .map { |row| row.map(&{ BLACK => ' ', WHITE => '*' }) }
  .map(&:join)
