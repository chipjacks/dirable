module Dirable
  class LocalFS
    extend Forwardable

    def append(path, output)
      File.open(path, 'a') do |f|
        f << output << "\n"
      end
    end

    def ls(path)
      ::Dir.entries(path).reject { |file|
          File.basename(file).start_with?('.')
        }
    end

    def mkdir(path)
      FileUtils.mkdir(path)
    rescue Errno::EEXIST => e
      false
    end

    def rm_r(path)
      rm_r!(path)
    rescue FileNotFoundError => e
      nil
    end

    def rm_r!(path)
      FileUtils.rm_r(path)
    rescue Errno::ENOENT => e
      raise FileNotFoundError.new("File #{path} not found")
    end

    def_delegator :FileUtils, :move, :mv

    def read(path)
      rescue_read_errors(path) do
        File.read(path)
      end
    end

    def tip_of_tail(path)
      rescue_read_errors(path) do
        File.open(path) do |f|
          return f.readlines[-1].strip
        end
      end
    end

    private

    def rescue_read_errors(path, &block)
      block.call
    rescue Errno::EISDIR => e
      raise InvalidOpError.new("Path is a directory: #{path}")
    rescue Errno::ENOENT => e
      raise FileNotFoundError.new("File #{path} not found")
    end

  end
end
