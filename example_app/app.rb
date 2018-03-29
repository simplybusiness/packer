# Requires the Gemfile
require 'bundler' ; Bundler.require

class ExampleApp < Sinatra::Base
  helpers Packer::Helper

  get '/' do
    erb :index
  end
end
