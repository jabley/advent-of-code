require_relative "./amps"

input = File.read("input.txt").strip.split(",").map(&:to_i)

max = [*(0..4)].permutation.map do |sequence|
    amps = Amps.new(input)
    amps.sequential(sequence)
end.max

puts "Part1: #{ max }"

max = [*(5..9)].permutation.map do |sequence|
    amps = Amps.new(input)
    amps.feedback(sequence)
end.max

puts "Part2: #{ max }"
