# frozen_string_literal: true

require 'socket'

module Packer
  class DevServer
    delegate :config, :env, to: :@packer

    # Configure dev server connection timeout (in seconds), default: 0.01
    # Packer.dev_server.connect_timeout = 1
    cattr_accessor(:connect_timeout) { 0.01 }

    def initialize(packer)
      @packer = packer
    end

    def running?
      return false unless env == 'development'

      Socket.tcp(host, port, connect_timeout: connect_timeout).close
      true
    rescue StandardError
      false
    end

    def host
      'localhost'
    end

    def port
      3035
    end

    def host_with_port
      "#{host}:#{port}"
    end
  end
end
