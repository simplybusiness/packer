# spec/spec_helper.rb
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../app.rb', File.dirname(__FILE__)

module RSpecMixin
  include Rack::Test::Methods
  def app() ExampleApp end
end

RSpec.configure { |c| c.include RSpecMixin }
