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

  def eval
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
        val = get_input
        puts "SetInputAt #{ val } into (Position #{ @p[ip+1] })" if @debug
        @p[@p[ip+1]] = get_input
        ip += 2
      when 4 # print
        mode = extract_mode(instruction, FIRST_PARAMETER_MODE)
        val  = read_value(ip+1, mode)
        puts "Print (Position #{ @p[ip+1] }) : #{ val }" if @debug
        @output = val
        ip += 2
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

def get_input
  1
end
