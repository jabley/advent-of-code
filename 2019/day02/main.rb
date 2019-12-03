require_relative "./computer"

input = File.read("input.txt").strip.split(",").map(&:to_i)
c = Computer.new(input)

# Before running the program, replace postion 1 with the value 12 and replace
# position 2 with the value 2

#puts "Value at position 1 is #{ c.get(1) }"
#puts "Value at position 2 is #{ c.get(2) }"

c.set(1, 12)
c.set(2, 2)

c.eval

# What value is left at position 0 after the program halts?
puts "Part1: #{ c.get(0) }"


(0..99).each do |noun|
  (0..99).each do |verb|
    c = Computer.new(input)
    c.set(1, noun)
    c.set(2, verb)

    c.eval

    if c.get(0) == 19690720
      puts "Part2: noun=#{ noun }, verb=#{ verb }, function=#{ 100 * noun + verb }"
    end
  end
end
