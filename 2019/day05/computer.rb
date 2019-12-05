class Computer
  FIRST_PARAMETER_MODE  = 100
  SECOND_PARAMETER_MODE = 1000
  THIRD_PARAMETER_MODE  = 10000 # always position mode

  IMMEDIATE_MODE = 1
  POSITION_MODE  = 0

  MODES = {
    IMMEDIATE_MODE => "Immediate",
    POSITION_MODE  => "Position",
  }

  attr_reader :output

  def initialize(input, debug = false)
    @p     = input.dup
    @debug = debug
  end

  def eval(input = 1)
    # start by looking at the first integer (called position 0)
    ip = 0

    loop do
      instruction = @p[ip]
      opcode      = instruction % 100

      puts "evaluating instruction #{ instruction } with opcode #{ opcode } at #{ ip }" if @debug

      case opcode
      when 1 # add
        mode1 = extract_mode(instruction, FIRST_PARAMETER_MODE)
        val1  = read_value(ip+1, mode1)
        mode2 = extract_mode(instruction, SECOND_PARAMETER_MODE)
        val2  = read_value(ip+2, mode2)
        puts "Add (#{ mode_type(mode1) } #{ @p[ip+1] }) + (#{ mode_type(mode2) } #{ @p[ip+2] }) into (Position #{ @p[ip+3] })" if @debug
        @p[@p[ip+3]] = val1 + val2
        ip += 4
      when 2 # mult
        mode1 = extract_mode(instruction, FIRST_PARAMETER_MODE)
        val1  = read_value(ip+1, mode1)
        mode2 = extract_mode(instruction, SECOND_PARAMETER_MODE)
        val2  = read_value(ip+2, mode2)
        puts "Mult (#{ mode_type(mode1) } #{ @p[ip+1] }) * (#{ mode_type(mode2) } #{ @p[ip+2] }) into (Position #{ @p[ip+3] })" if @debug
        @p[@p[ip+3]] = val1 * val2
        ip +=4
      when 3 # read
        puts "SetInputAt #{ input } into (Position #{ @p[ip+1] })" if @debug
        @p[@p[ip+1]] = input
        ip += 2
      when 4 # print
        mode1 = extract_mode(instruction, FIRST_PARAMETER_MODE)
        val1  = read_value(ip+1, mode1)
        puts "Print (Position #{ @p[ip+1] }) : #{ val1 }" if @debug
        @output = val1
        ip += 2
      when 5 # jump-if-true
        mode1 = extract_mode(instruction, FIRST_PARAMETER_MODE)
        val1  = read_value(ip+1, mode1)
        mode2 = extract_mode(instruction, SECOND_PARAMETER_MODE)
        val2  = read_value(ip+2, mode2)

        puts "JumpIfTrue (#{ mode_type(mode1) } #{ @p[ip+1] } – #{ val1 }) ((#{ mode_type(mode2) } #{ @p[ip+2] } – #{ val2 }))" if @debug

        ip = (not val1.zero?) ? val2 : ip+3
      when 6 # jump-if-false
        mode1 = extract_mode(instruction, FIRST_PARAMETER_MODE)
        val1  = read_value(ip+1, mode1)
        mode2 = extract_mode(instruction, SECOND_PARAMETER_MODE)
        val2  = read_value(ip+2, mode2)

        puts "JumpIfFalse (#{ mode_type(mode1) } #{ @p[ip+1] }) ((#{ mode_type(mode2) } #{ @p[ip+2] }))" if @debug

        ip = val1.zero? ? val2 : ip+3
      when 7 # less than
        mode1 = extract_mode(instruction, FIRST_PARAMETER_MODE)
        val1  = read_value(ip+1, mode1)
        mode2 = extract_mode(instruction, SECOND_PARAMETER_MODE)
        val2  = read_value(ip+2, mode2)

        @p[@p[ip+3]] = val1 < val2 ? 1 : 0

        ip += 4
      when 8 # equals
        mode1 = extract_mode(instruction, FIRST_PARAMETER_MODE)
        val1  = read_value(ip+1, mode1)
        mode2 = extract_mode(instruction, SECOND_PARAMETER_MODE)
        val2  = read_value(ip+2, mode2)

        @p[@p[ip+3]] = val1 == val2 ? 1 : 0

        ip += 4
      when 99 then break
      else raise "Invalid opcode #{ opcode }"
      end
    end
  end

  def get(pos)
    @p[pos]
  end

  def set(pos, val)
    @p[pos] = val
  end

  private

  def mode_type(mode)
    MODES[mode]
  end

  def extract_mode(value, bit)
    value / bit % 10
  end

  def read_value(pos, mode)
    case mode
    when IMMEDIATE_MODE
      @p[pos]
    when POSITION_MODE
      @p[@p[pos]]
    end
  end

end
