module Dirable
  class Record
    include Dirable

    attr_reader :dir, :name

    def initialize(parent, name)
      if parent.is_a? Table
        @parent = parent.parent
      else
        @parent = parent
      end
      @name = name
      @dir = Dir.new(parent.dir.path, name)
    end

    def on_delete
    end

    def has_many(table_name, dirable_class, opts = {})
      dirable_table_class = opts.fetch(:via, Table)
      dir.mkdir(table_name)
      table = dirable_table_class.new(self, table_name, dirable_class)
      define_singleton_method(table_name) { table.reload }
    end

    def has_one(name, dirable_class, opts = {})
      dir.mkdir(name) if opts.fetch(:make, true)
      record = dirable_class.new(self, name)
      define_singleton_method(name) { record }
    end

    def has_attribute(name)
      attribute = Attribute.new(self, name)
      define_singleton_method(name) { attribute.reload }
      define_singleton_method("#{name}=") { |value| attribute.set(value) }
    end

  end
end
