require "scanf"

Point3D = Struct.new(:x, :y, :z) do
    def to_s
        "<x=#{ x }, y=#{ y }, z=#{ z }>"
    end
end

Moon = Struct.new(:position, :velocity) do
    def self.build(x, y, z)
        Moon.new(Point3D.new(x, y, z), Point3D.new(0, 0, 0))
    end

    def to_s
        "pos=#{ position }, vel=#{ velocity }"
    end

    def total_energy
        potential_energy * kinetic_energy
    end

    private

    def potential_energy
        position.sum(&:abs)
    end

    def kinetic_energy
        velocity.sum(&:abs)
    end
end

System = Struct.new(:moons) do
    def self.parse(input)
        System.new(input.each_line
            .flat_map { |line|
                line.strip.scanf("<x=%d, y=%d , z=%d>") { |x, y, z|
                    Moon.build(x, y, z)
                }
            }
        )
    end

    def step
        apply_gravity(moons)
        apply_velocity(moons)
    end

    def total_energy
        moons.sum(&:total_energy)
    end
end
def apply_gravity(moons)
    moons.permutation(2).each do |(a, b)|
        a.velocity.x += b.position.x <=> a.position.x
        a.velocity.y += b.position.y <=> a.position.y
        a.velocity.z += b.position.z <=> a.position.z
    end
end

def apply_velocity(moons)
    moons.each { |moon|
        moon.position.x += moon.velocity.x
        moon.position.y += moon.velocity.y
        moon.position.z += moon.velocity.z
    }
end
