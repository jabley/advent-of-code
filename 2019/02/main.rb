require_relative "./computer"

input = File.read(File.expand_path("../input.txt", __FILE__))
c = Computer.new(input)

# Before running the program, replace postion 1 with the value 12 and replace
# position 2 with the value 2

#puts "Value at position 1 is #{ c.get(1) }"
#puts "Value at position 2 is #{ c.get(2) }"

c.memory[1] = 12
c.memory[2] = 2

c.eval

# What value is left at position 0 after the program halts?
puts "Part1: #{ c.memory[0] }"

(0..99).each do |noun|
  (0..99).each do |verb|
    c = Computer.new(input)
    c.memory[1] = noun
    c.memory[2] = verb

    c.eval

    if c.memory[0] == 19690720
      puts "Part2: noun=#{ noun }, verb=#{ verb }, function=#{ 100 * noun + verb }"
      exit 0
    end
  end
end
