# frozen_string_literal: true

require 'packer/configuration'

namespace :packer do
  desc 'Verifies if Packer is installed'
  task :verify_install do
    if Packer.config.config_path.exist?
      $stdout.puts 'Packer is installed 🎉 🍰 🎉'
      $stdout.puts "Using #{Packer.config.config_path} file for setting up webpack paths"
    else
      warn "Configuration #{Packer.config.config_path} file not found. \n"\
           'Make sure packer:install is run successfully before ' \
           'running dependent tasks'
      exit!
    end
  end
end
