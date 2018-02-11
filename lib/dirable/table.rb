module Dirable
  class Table
    extend Forwardable

    attr_reader :dir, :name, :records, :parent

    def initialize(parent, name, child_class)
      @parent = parent
      @name = name
      @record_class = child_class
      @dir = Dirable::Dir.new(parent.dir.path, name)
      @records = {}
      reload
    end

    def_delegators :records, :keys, :values, :size, :each, :fetch, :[]

    def reload
      new = dir.ls.to_set
      old = records.keys.to_set
      to_add = new - old
      to_del = old - new
      to_add.each { |name| add(name) }
      to_del.each { |name| records.delete(name) }
      self
    end

    def add(name)
      if name.nil? || name.empty?
        raise "Name is empty or missing."
      elsif records[name]
        raise "A record already exists with the name: #{name}"
      end
      dir.mkdir(name)
      records[name] = @record_class.new(self, name)
      records[name]
    end

    def delete(name)
      if !records[name]
        raise "No record exists with the name: #{name}"
      end
      records[name].on_delete
      begin
        dir.rm_r(name)
      rescue FileNotFoundError => e
        nil
      end
      records.delete(name)
    end

  end
end
