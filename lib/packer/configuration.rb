# frozen_string_literal: true

require 'active_support/core_ext/hash'
require 'psych'
require 'yaml'

module Packer
  class Configuration
    delegate :root_path, :config_path, :env, to: :@packer

    def initialize(packer)
      @packer = packer
    end

    def refresh
      @data = load
    end

    def compile?
      fetch(:compile)
    end

    def source_path
      root_path.join(fetch(:source_path))
    end

    def resolved_paths
      []
    end

    def resolved_paths_globbed
      resolved_paths.map { |p| "#{p}/**/*" }
    end

    def source_entry_path
      source_path.join(fetch(:source_entry_path))
    end

    def public_path
      root_path.join(fetch(:public_path))
    end

    def public_output_path
      public_path.join(fetch(:public_output_path))
    end

    def public_manifest_path
      public_output_path.join('manifest.json')
    end

    def cache_manifest?
      fetch(:cache_manifest)
    end

    def cache_path
      root_path.join(fetch(:cache_path))
    end

    private

    def fetch(key)
      data.fetch(key)
    end

    def data
      @data ||= load
    end

    def load
      # rubocop:disable Security/YAMLLoad
      YAML.load_file(config_path)[env].deep_symbolize_keys
      # rubocop:enable Security/YAMLLoad
    rescue Errno::ENOENT => e
      raise "Packer configuration file not found #{config_path}. " \
            "Error: #{e.message}"
    rescue Psych::SyntaxError => e
      raise "YAML syntax error occurred while parsing #{config_path}. " \
            'Please note that YAML must be consistently indented using spaces. Tabs are not allowed. ' \
            "Error: #{e.message}"
    end
  end
end
