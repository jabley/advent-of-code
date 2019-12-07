require_relative "./computer"

class Amps
    def initialize(input)
        @a = Computer.new(input)
        @b = Computer.new(input)
        @c = Computer.new(input)
        @d = Computer.new(input)
        @e = Computer.new(input)
    end

    def run(phases)
        @a.eval([phases[0], 0])
        @b.eval([phases[1], @a.output])
        @c.eval([phases[2], @b.output])
        @d.eval([phases[3], @c.output])
        @e.eval([phases[4], @d.output])

        @e.output
    end
end
