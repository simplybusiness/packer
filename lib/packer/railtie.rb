require "rails/railtie"

require "packer/helper"
require "packer/dev_server_proxy"

class Packer::Engine < ::Rails::Engine
  initializer "packer.proxy" do |app|
    if Rails.env.development?
      app.middleware.insert_before 0,
        Rails::VERSION::MAJOR >= 5 ?
          Packer::DevServerProxy : "Packer::DevServerProxy", ssl_verify_none: true
    end
  end

  initializer "packer.helper" do
    ActiveSupport.on_load :action_controller do
      ActionController::Base.helper Packer::Helper
    end

    ActiveSupport.on_load :action_view do
      include Packer::Helper
    end
  end

  initializer "packer.logger" do
    config.after_initialize do
      if ::Rails.logger.respond_to?(:tagged)
        Packer.logger = ::Rails.logger
      else
        Packer.logger = ActiveSupport::TaggedLogging.new(::Rails.logger)
      end
    end
  end

  initializer "packer.bootstrap" do
    if defined?(Rails::Server) || defined?(Rails::Console)
      Packer.bootstrap
      Spring.after_fork { Packer.bootstrap } if defined?(Spring)
    end
  end
end
