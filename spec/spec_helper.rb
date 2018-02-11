require "bundler/setup"
require "dirable"
require "pry"

class Root < Dirable::Record
end

Dirable.configure do |config|
  config.root_dir = '/tmp/dirable_test'
  config.root_class = Root
end

RSpec.configure do |config|
  config.before(:each) do
    Dirable.fs.rm_r(Dirable.config.root_dir)
    Dirable.fs.mkdir(Dirable.config.root_dir)
  end
end

include Dirable
