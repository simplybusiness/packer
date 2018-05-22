# frozen_string_literal: true

module Packer
  class Env
    DEFAULT = "development"

    delegate :config_path, :logger, to: :@packer

    def self.inquire(packer)
      new(packer).inquire
    end

    def initialize(packer)
      @packer = packer
    end

    def inquire
      fallback_env_warning unless current
      current || DEFAULT
    end

    private

    def current
      current_env if available_environments.include?(current_env)
    end

    def fallback_env_warning
      env_variable = Packer.rails? ? "RAILS_ENV=#{rails_env}" : "RACK_ENV=#{sinatra_env}"
      logger.info "#{env_variable} environment is not defined in config/packer.yml, falling back to #{DEFAULT} environment"
    end

    def current_env
      sinatra_env || rails_env
    end

    def sinatra_env
      ::Sinatra::Base.environment if Packer.sinatra?
    end

    def rails_env
      ::Rails.env if Packer.rails?
    end

    def available_environments
      if File.exist? config_path
        YAML.load_file(config_path).keys
      else
        [].freeze
      end
    rescue Psych::SyntaxError => e
      raise "YAML syntax error occurred while parsing #{config_path}. " \
            "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            "Error: #{e.message}"
    end
  end
end
