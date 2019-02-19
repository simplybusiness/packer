# frozen_string_literal: true

require 'json'

module Packer
  class Manifest
    class MissingEntryError < StandardError; end

    delegate :config, :installer, :compiler, :dev_server, to: :@packer

    def initialize(packer)
      @packer = packer
    end

    def refresh
      @data = load
    end

    def lookup(name)
      if compiling?
        install
        compile
      end
      find name
    end

    def lookup!(name)
      lookup(name) || handle_missing_entry(name)
    end

    private

    def compiling?
      config.compile? && !dev_server.running?
    end

    def install
      Packer.logger.tagged('Packer') { installer.install }
    end

    def compile
      Packer.logger.tagged('Packer') { compiler.compile }
    end

    def find(name)
      data[name.to_s].presence
    end

    def handle_missing_entry(name)
      raise Packer::Manifest::MissingEntryError, missing_file_from_manifest_error(name)
    end

    def missing_file_from_manifest_error(bundle_name)
      <<~MSG
        Packer can't find #{bundle_name} in #{config.public_manifest_path}. Possible causes:
        1. You want to set packer.yml value of compile to true for your environment
          unless you are using the `webpack -w` or the webpack-dev-server.
        2. webpack has not yet re-run to reflect updates.
        3. You have misconfigured Packer's packer.yml file.
        4. You have not installed dependencies `yarn install`.
        5. Your webpack configuration is not creating a manifest.
        Your manifest contains:
        #{JSON.pretty_generate(@data)}
        MSG
    end

    def data
      if config.cache_manifest?
        @data ||= load
      else
        refresh
      end
    end

    def load
      if config.public_manifest_path.exist?
        JSON.parse config.public_manifest_path.read
      else
        {}
      end
    end
  end
end
