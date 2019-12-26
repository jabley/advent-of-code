class Computer
  POSITION_MODE  = 0
  IMMEDIATE_MODE = 1
  RELATIVE_MODE  = 2

  attr_accessor :inputs, :outputs
  attr_reader :memory

  def initialize(program, inputs: [], outputs: [])
    @memory  = program.strip.split(",").map(&:to_i)
    @inputs  = inputs
    @outputs = outputs
    @ip      = 0
    @base    = 0
  end

  def eval
    loop do
      instruction = mem(@ip)
      opcode      = instruction % 100
      case opcode
      when 1 # add
        write(3, read(1) + read(2))
        @ip += 4
      when 2 # mult
        write(3, read(1) * read(2))
        @ip += 4
      when 3 # read
        write(1, @inputs.shift)
        @ip += 2
      when 4 # print
        value = read(1)
        @ip += 2
        @outputs.push(value)
      when 5 # jump-if-true
        @ip = (read(1) == 0) ? @ip + 3 : read(2)
      when 6 # jump-if-false
        @ip = (read(1) == 0) ? read(2) : @ip + 3
      when 7 # less than
        write(3, read(1) < read(2) ? 1 : 0)
        @ip += 4
      when 8 # equals
        write(3, read(1) == read(2) ? 1 : 0)
        @ip += 4
      when 9 # adjust-relative-base
        @base += read(1)
        @ip += 2
      when 99 then break
      end

    end
  end

  private

  def mem(address)
    @memory.fetch(address, 0)
  end

  def mode(offset)  
    (mem(@ip) / (10**(offset+1))) % 10
  end

  def read(offset)
    case mode(offset)
    when POSITION_MODE  then mem(mem(@ip + offset))
    when IMMEDIATE_MODE then mem(@ip + offset)
    when RELATIVE_MODE  then mem(mem(@ip + offset) + @base)
    else raise "Unknown mode"
    end
  end

  def write(offset, value)
    if value.nil?
      raise "Cannot write nil value"
    end
    case mode(offset)
    when POSITION_MODE  then @memory[mem(@ip + offset)] = value
    when IMMEDIATE_MODE then @memory[@ip + offset] = value
    when RELATIVE_MODE  then @memory[mem(@ip + offset) + @base] = value
    else raise "Unknown mode"
    end
  end

end
