require_relative "./celestial"

input = File.read("input.txt").strip\

com = parse(input.strip)["COM"]

puts "Part1: #{ get_total_orbits(com) }"
