require_relative "./computer"

require "test/unit"

class TestExamples < Test::Unit::TestCase

    def to_instructions(s)
        s.strip.split(",").map(&:to_i)
      end

    def new_computer(input)
        Computer.new(to_instructions(input))
    end

    def test_first
        p = new_computer("1,9,10,3,2,3,11,0,99,30,40,50")
        p.eval
        assert_equal(3500, p.get(0))
    end

    def test_second
        p = new_computer("1,0,0,0,99")
        p.eval
        assert_equal(2, p.get(0))
      end

      def test_third
        p = new_computer("2,3,0,3,99")
        p.eval
        assert_equal(6, p.get(3))
      end

      def test_fourth
        p = new_computer("2,4,4,5,99,0")
        p.eval
        assert_equal(9801, p.get(5))
      end

      def test_fifth
        p = new_computer("1,1,1,4,99,5,6,0,99")
        p.eval
        assert_equal(30, p.get(0))
        assert_equal(2, p.get(4))
      end

      def test_sixth
        p = new_computer("1002,4,3,4,33")
        p.eval
        assert_equal(99, p.get(4))
      end
end
