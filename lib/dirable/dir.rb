module Dirable
  class Dir

    attr_accessor :path

    def initialize(root, *rel_path)
      @path = File.join(root, *rel_path)
    end

    def ls(relative_path = '')
      Dirable.fs.ls(File.join(path, relative_path))
    end

    def mkdir(relative_path = '')
      Dirable.fs.mkdir(File.join(path, relative_path))
    end

    def rm_r(relative_path = '')
      Dirable.fs.rm_r(File.join(path, relative_path))
    end

    def store(key, value)
      Dirable.fs.append(File.join(path, key), value.to_s)
    end

    def fetch(key)
      fetch!(key)
    rescue KeyError => e
      nil
    end

    def fetch!(key)
      Dirable.fs.tip_of_tail(File.join(path, key))
    rescue FileNotFoundError => e
      raise KeyError.new("key not found: \"#{key}\"")
    end

  end
end
