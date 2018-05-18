# frozen_string_literal: true

require 'pathname'

module Packer
  class Instance
    cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

    attr_reader :root_path, :config_path

    delegate :compile, to: :compiler

    def initialize(root_path: nil, config_path: nil)
      @root_path = root_path || app_root_path
      @config_path = config_path || File.join(@root_path, 'config/packer.yml')
    end

    def env
      @env ||= Packer::Env.inquire self
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

    private

    def app_root_path
      if Packer.rails?
        Rails.root
      elsif Packer.sinatra?
        Sinatra::Base.settings.root || Pathname('.')
      else
        raise 'Packer is running in unsupported environment'
      end
    end
  end
end
