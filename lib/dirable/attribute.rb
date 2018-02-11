module Dirable
  class Attribute

    def initialize(parent, name)
      @parent = parent
      @name = name
      @dir = Dirable::Dir.new(parent.dir.path)
      reload
    end

    def reload
      @value = @dir.fetch(@name)
    end

    def set(value)
      @dir.store(@name, value)
      @value = value
    end

    def get
      @value
    end

  end
end
