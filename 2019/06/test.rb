require_relative "./celestial"

require "test/unit"

class TestExamples < Test::Unit::TestCase

  def test_first
    example = <<~MSG
      COM)B
      B)C
      C)D
      D)E
      E)F
      B)G
      G)H
      D)I
      E)J
      J)K
      K)L
    MSG

    orbit_map = parse(example.strip)
    assert_equal(12, orbit_map.size) # we have 12 celestial bodies (including the COM)
    assert_equal(42, get_total_orbits(orbit_map["COM"]))
  end

end
