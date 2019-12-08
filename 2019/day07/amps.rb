require_relative "./computer"

class Amps
    def initialize(program)
        @program = program
    end

    def sequential(phases)
        first_input = 0

        phases.reduce(first_input) do |input, phase_setting|
            amp = Computer.new(@program, input: [phase_setting, input], output: [], debug: false)
            amp.eval
            amp.output.first
        end
    end

    def feedback(phases)
        channels = phases.map { |phase_setting| Queue.new.push(phase_setting) }

        threads = phases.map.with_index do |_,i|
            Thread.new do
                amp = Computer.new(
                    @program,
                    input: channels[i],
                    output: channels[(i+1)%channels.length]
                )
                amp.eval
            end
        end

        channels.first.push(0)
        threads.each(&:join)
        channels.first.pop
    end
end