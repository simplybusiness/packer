# frozen_string_literal: true

namespace :packer do
  desc 'Install Yarn packages required for Packer asset compilation'
  task :install do
    $stdout.puts 'Installing Yarn packages…'
    system('yarn install --no-progress --non-interactive')
  end
end
