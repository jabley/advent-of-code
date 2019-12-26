class Body
    attr_accessor :children, :parent, :name

    def initialize(name)
      self.name     = name
      self.parent   = nil
      self.children = []
    end

    def add_child(child)
      child.parent  = self
      self.children << child
    end

  end

  def parse(map_data)
    map_data.lines.map(&:strip).reduce({}) do |memo, relationship|
      body_name, child_name = relationship.split(")")
      body  = memo[body_name]  ||= Body.new(body_name)
      child = memo[child_name] ||= Body.new(child_name)

      body.add_child(child)

      memo[body_name]  = body
      memo[child_name] = child

      memo
    end
  end

  def get_total_orbits(body, previous=0)
    previous + body.children.reduce(0) do |memo, child|
      memo + get_total_orbits(child, previous+1)
    end
  end
