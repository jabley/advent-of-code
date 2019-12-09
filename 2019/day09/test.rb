require_relative "./computer"

require "test/unit"

class TestExamples < Test::Unit::TestCase

    def to_instructions(s)
        s.strip.split(",").map(&:to_i)
    end

    def new_computer(input)
        Computer.new(to_instructions(input), debug: false)
    end

    def test_first
        c = new_computer("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
        c.eval
        assert_equal "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99", c.output.join(",")
    end

    def test_second
        c = new_computer("1102,34915192,34915192,7,4,7,99,0")
        c.eval
        assert_equal 1219070632396864, c.output.first
        assert_equal 16, c.output.first.to_s.length
    end

    def test_third
        computer = new_computer("104,1125899906842624,99")
        computer.eval
        assert_equal 1125899906842624, computer.output.first
    end
end
