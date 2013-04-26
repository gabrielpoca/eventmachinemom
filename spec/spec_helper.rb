$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'eventmachinemom'
require_relative 'lib/web_socket'


thread = nil

RSpec.configure do |c|
  c.before(:all) do
    thread = Thread.new do
      EventMachineMOM::Application.new
    end
  end
  c.after(:all) do
    thread.kill
  end
end

