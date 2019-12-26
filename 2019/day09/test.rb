require_relative "../day02/computer"

require "test/unit"

class TestExamples < Test::Unit::TestCase

    def new_computer(input)
        Computer.new(input)
    end

    def test_first
        c = new_computer("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
        c.eval
        assert_equal "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99", c.outputs.join(",")
    end

    def test_second
        c = new_computer("1102,34915192,34915192,7,4,7,99,0")
        c.eval
        assert_equal 1219070632396864, c.outputs.first
        assert_equal 16, c.outputs.first.to_s.length
    end

    def test_third
        computer = new_computer("104,1125899906842624,99")
        computer.eval
        assert_equal 1125899906842624, computer.outputs.first
    end
end
