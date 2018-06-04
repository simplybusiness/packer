# frozen_string_literal: true

require 'pathname'

module Packer
  class Instance
    cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

    attr_reader :root_path, :config_path

    delegate :compile, to: :compiler

    def initialize(root_path: nil, config_path: nil)
      @root_path = determine_root_path(root_path)
      @config_path = config_path || Pathname.new(File.join(@root_path, 'config/packer.yml'))
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

    def determine_root_path(root_path)
      if root_path.present?
        Pathname.new(root_path)
      elsif Packer.rails?
        Rails.root
      else
        raise ArgumentError, "root_path is not set"
      end
    end
  end
end
