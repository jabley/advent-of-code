class Computer
  Parameter = Struct.new(:mode, :value, :index) do

    IMMEDIATE_MODE = 1
    POSITION_MODE  = 0

    MODES = {
      IMMEDIATE_MODE => "Immediate",
      POSITION_MODE  => "Position",
    }

    def self.parse(instruction, ip, position, intcodes)
      mode  = (instruction / (10**(position+1))) % 10
      index = intcodes[ip+position]

      value = case mode
      when IMMEDIATE_MODE
        index
      when POSITION_MODE
        intcodes[index]
      end

      Parameter.new(mode, value, index)
    end

    def to_s
      "(#{ mode_type } #{ index })"
    end

    def mode_type
      MODES[mode]
    end
  end

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

      break if opcode == 99

      # All other opcodes take at least a single parameter.
      p1 = Parameter.parse(instruction, ip, 1, @p)

      # We can safely parse as a parameter the opcode which follows opcodes that only have a
      # single parameter (read and print)
      p2 = Parameter.parse(instruction, ip, 2, @p)

      case opcode
      when 1 # add
        puts "Add #{ p1 } + #{ p2 } into (Position #{ @p[ip+3] })" if @debug
        @p[@p[ip+3]] = p1.value + p2.value
        ip += 4
      when 2 # mult
        puts "Mult #{ p1 } * #{ p2 } into (Position #{ @p[ip+3] })" if @debug
        @p[@p[ip+3]] = p1.value * p2.value
        ip +=4
      when 3 # read
        puts "SetInputAt #{ input } into (Position #{ p1.index })" if @debug
        @p[p1.index] = input
        ip += 2
      when 4 # print
        puts "Print #{ p1 } : #{ p1.value }" if @debug
        @output = p1.value
        ip += 2
      when 5 # jump-if-true
        puts "JumpIfTrue #{ p1 } #{ p2 }" if @debug
        ip = p1.value.nonzero? ? p2.value : ip+3
      when 6 # jump-if-false
        puts "JumpIfFalse #{ p1 } #{ p2 }" if @debug
        ip = p1.value.zero? ? p2.value : ip+3
      when 7 # less than
        puts "LessThan #{ p1 } #{ p2 }" if @debug
        @p[@p[ip+3]] = p1.value < p2.value ? 1 : 0
        ip += 4
      when 8 # equals
        puts "Equals #{ p1 } #{ p2 }" if @debug
        @p[@p[ip+3]] = p1.value == p2.value ? 1 : 0
        ip += 4
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

end
