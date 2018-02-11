require 'ostruct'

require "dirable/version"
require "dirable/config"
require "dirable/error"
require "dirable/local_fs"
require "dirable/dir"
require "dirable/record"
require "dirable/table"
require "dirable/attribute"

module Dirable
  class << self
    attr_writer :config
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config)
  end

  def self.fs
    @fs ||= config.fs_interface.new
  end

  def self.root
    return @root if @root
    dir = OpenStruct.new(dir: @dir ||= Dir.new(File.dirname(config.root_dir)))
    unless config.root_class
      raise "You gotta configure a root class!"
    end
    @root = config.root_class.new(dir, File.basename(config.root_dir))
  end
end
