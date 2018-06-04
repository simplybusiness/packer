# frozen_string_literal: true

require 'packer'
require 'packer/helper'
require 'packer/dev_server_proxy'

module Packer
  module Sinatra
    def self.registered(app)
      Packer.instance = Packer::Instance.new(root_path: app.settings.root)
      app.helpers Packer::Helper
      app.use Packer::DevServerProxy if ENV['RACK_ENV'] == 'development'
    end
  end
end
