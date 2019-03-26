# frozen_string_literal: true

require 'packer/version'

namespace :packer do
  desc "Provide information on Packer's environment"
  task :info do
    $stdout.puts "Ruby: #{`ruby --version`}"
    $stdout.puts "Rails: #{Rails.version}"
    $stdout.puts "Packer: #{Packer::VERSION}"
    $stdout.puts "Node: #{`node --version`}"
    $stdout.puts "Yarn: #{`yarn --version`}"
  end
end
