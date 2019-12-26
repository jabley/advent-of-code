require "test/unit"

require_relative "./simulation"

class TestExamples < Test::Unit::TestCase
    def test_first
        input = <<~TEST
            <x=-1, y=0, z=2>
            <x=2, y=-10, z=-7>
            <x=4, y=-8, z=8>
            <x=3, y=5, z=-1>
        TEST

        system = System.parse(input.strip)

        10.times { system.step }

        assert_equal 179, system.total_energy
    end
end
