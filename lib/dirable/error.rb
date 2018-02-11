module Dirable
  class Error < StandardError
    attr_accessor :metadata

    def initialize(message, metadata = {})
      super(message)
      @metadata = metadata
    end
  end

  class FSError < Error; end
  class InvalidOpError < FSError; end
  class FileNotFoundError < FSError; end
end
