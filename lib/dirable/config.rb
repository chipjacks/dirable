module Dirable
  class Config

    attr_accessor :fs_interface, :root_dir, :root_class

    def initialize
      @fs_interface = Dirable::LocalFS
      @root_dir = '/tmp/dirable'
      @root_class = nil
    end

  end
end
