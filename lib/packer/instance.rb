# frozen_string_literal: true

require 'pathname'

module Packer
  class Instance
    cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

    attr_reader :root_path, :config_path, :env

    delegate :compile, to: :compiler

    def initialize(root_path: nil, config_path: nil, environment: nil)
      @root_path = determine_root_path(root_path)
      @config_path = config_path || Pathname.new(File.join(@root_path, 'config/packer.yml'))
      raise ArgumentError, "Missing packer configuration file #{@config_path}" unless File.exist?(@config_path)
      @env = determine_environment(environment)
    end

    def compiler
      @compiler ||= Packer::Compiler.new self
    end

    def installer
      @installer ||= Packer::Installer.new self
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

    def determine_environment(env)
      env = if env.present?
              env.to_s
            elsif Packer.rails?
              ::Rails.env.to_s
            end
      raise ArgumentError, 'environment is not set' if env.nil?
      unless available_environments.include?(env.to_s)
        raise ArgumentError, "#{env} env is not defined in #{@config_path}"
      end
      env
    end

    def determine_root_path(root_path)
      root_path = if root_path.present?
                    Pathname.new(root_path)
                  elsif Packer.rails?
                    ::Rails.root
                  end
      raise ArgumentError, 'root_path is not set' if root_path.nil?
      root_path
    end

    def available_environments
      YAML.load_file(config_path).keys
    end
  end
end
