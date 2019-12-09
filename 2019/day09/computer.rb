class Computer
    Parameter = Struct.new(:mode, :value, :write, :index) do

      RELATIVE_MODE = 2
      IMMEDIATE_MODE = 1
      POSITION_MODE  = 0

      MODES = {
        IMMEDIATE_MODE => "Immediate",
        POSITION_MODE  => "Position",
        RELATIVE_MODE  => "Relative",
      }

      def self.parse(instruction, ip, relative_base, position, memory)
        mode  = (instruction / (10**(position+1))) % 10
        index = memory[ip+position]

        case mode
        when RELATIVE_MODE
          value = memory[relative_base+index]
          write = ->(val) { memory[relative_base+index] = val }
        when IMMEDIATE_MODE
          value = index
          write = ->(val) { raise "Unsupported operation" }
        when POSITION_MODE
          value = memory[index]
          write = ->(val) { memory[index] = val }
        end

        Parameter.new(mode, value, write, index)
      end

      def to_s
        "(#{ mode_type } #{ index })"
      end

      def mode_type
        MODES[mode]
      end
    end

    attr_reader :output

    def initialize(program, input: [], output: [], debug: false)
      @memory = program.reduce(Hash.new { |h, k| h[k] = 0}) do |acc, val|
        acc[acc.size] = val
        acc
      end
      @input  = input
      @output = output
      @debug  = debug
    end

    def eval
      # start by looking at the first integer (called position 0)
      ip = 0
      relative_base = 0

      loop do
        instruction = @memory[ip]
        opcode      = instruction % 100

        puts "evaluating instruction #{ instruction } with opcode #{ opcode } at #{ ip }" if @debug

        break if opcode == 99

        # All other opcodes take at least a single parameter.
        p1 = Parameter.parse(instruction, ip, relative_base, 1, @memory)

        # We can safely parse as a parameter the opcode which follows opcodes that only have a
        # single parameter (read and print)
        p2 = Parameter.parse(instruction, ip, relative_base, 2, @memory)

        p3 = Parameter.parse(instruction, ip, relative_base, 3, @memory)

        case opcode
        when 1 # add
          puts "Add #{ p1 } + #{ p2 } into (Position #{ @memory[ip+3] })" if @debug
          p3.write.call(p1.value + p2.value)
          ip += 4
        when 2 # mult
          puts "Mult #{ p1 } * #{ p2 } into (Position #{ @memory[ip+3] })" if @debug
          p3.write.call(p1.value * p2.value)
          ip +=4
        when 3 # read
          val = @input.shift
          puts "SetInputAt #{ val } into (Position #{ p1.index })" if @debug
          ip += 2
          p1.write.call(val)
        when 4 # print
          puts "Print #{ p1 } : #{ p1.value }" if @debug
          @output.push(p1.value)
          ip += 2
        when 5 # jump-if-true
          puts "JumpIfTrue #{ p1 } #{ p2 }" if @debug
          ip = p1.value.nonzero? ? p2.value : ip+3
        when 6 # jump-if-false
          puts "JumpIfFalse #{ p1 } #{ p2 }" if @debug
          ip = p1.value.zero? ? p2.value : ip+3
        when 7 # less than
          puts "LessThan #{ p1 } #{ p2 }" if @debug
          p3.write.call( (p1.value < p2.value) ? 1 : 0 )
          ip += 4
        when 8 # equals
          puts "Equals #{ p1 } #{ p2 }" if @debug
          p3.write.call( (p1.value == p2.value) ? 1 : 0 )
          ip += 4
        when 9 #adjust-relative-base
          puts "AdjustRelativeBase #{ p1 }" if @debug
          relative_base += p1.value
          ip += 2
        else raise "Invalid opcode #{ opcode }"
        end
      end
    end

  end
