class Computer
    def initialize(input)
      @p = input.dup
    end

    def eval
      # start by looking at the first integer (called position 0)
      ip = 0

      loop do
        opcode = @p[ip]
        #puts "evaluating opcode #{ opcode } at #{ ip }"
        case opcode
        when 1  then @p[@p[ip+3]] = @p[@p[ip+1]] + @p[@p[ip+2]]
        when 2  then @p[@p[ip+3]] = @p[@p[ip+1]] * @p[@p[ip+2]]
        when 99 then break
        else raise "Invalid opcode #{ opcode }"
        end

        # once you're done with an opcode, move to the next one by stepping forward 4 positions.
        ip += 4
     end

    end

    def get(pos)
      @p[pos]
    end

    def set(pos, val)
      @p[pos] = val
    end

  end
