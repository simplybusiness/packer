# frozen_string_literal: true

require 'rails/railtie'

require 'packer/helper'
require 'packer/dev_server_proxy'

module Packer
  class Engine < ::Rails::Engine
    initializer 'packer.proxy' do |app|
      app.middleware.insert_before 0, Packer::DevServerProxy, ssl_verify_none: true if Rails.env.development?
    end

    initializer 'packer.helper' do
      ActiveSupport.on_load :action_controller do
        ActionController::Base.helper Packer::Helper
      end

      ActiveSupport.on_load :action_view do
        include Packer::Helper
      end
    end

    initializer 'packer.logger' do
      config.after_initialize do
        Packer.logger = if ::Rails.logger.respond_to?(:tagged)
                          ::Rails.logger
                        else
                          ActiveSupport::TaggedLogging.new(::Rails.logger)
                        end
      end
    end

    initializer 'packer.bootstrap' do
      if defined?(Rails::Server) || defined?(Rails::Console)
        Packer.bootstrap
        Spring.after_fork { Packer.bootstrap } if defined?(Spring)
      end
    end
  end
end
