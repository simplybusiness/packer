# frozen_string_literal: true

require 'pathname'

module Packer
  class Instance
    cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

    attr_reader :root_path, :config_path

    delegate :compile, to: :compiler

    def initialize(root_path: Pathname('.'), config_path: Pathname('config/packer.yml'))
      @root_path = root_path
      @config_path = config_path
    end

    def env
      @env ||= ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def compiler
      @compiler ||= Packer::Compiler.new self
    end

    def config
      @config ||= Packer::Configuration.new self
    end

    def manifest
      @manifest ||= Packer::Manifest.new self
    end

    def dev_server
      @dev_server ||= Packer::DevServer.new self
    end

    def commands
      @commands ||= Packer::Commands.new self
    end
  end
end
