# Requires the Gemfile
require 'bundler' ; Bundler.require
require 'packer/sinatra'

class ExampleApp < Sinatra::Base
  register Packer::Sinatra

  get '/' do
    erb :index
  end
end
