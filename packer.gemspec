# frozen_string_literal: true

lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'packer/version'

gem_version = if ENV['GEM_PRE_RELEASE'].nil? || ENV['GEM_PRE_RELEASE'].empty?
                Packer::VERSION
              else
                "#{Packer::VERSION}.#{ENV['GEM_PRE_RELEASE']}"
              end

Gem::Specification.new do |spec|
  spec.name          = 'packer'
  spec.version       = gem_version
  spec.authors       = ['Leslie Hoare']
  spec.email         = ['iam@lesleh.co.uk']

  spec.summary       = 'Library to tie together any rack app with Webpack'
  spec.homepage      = 'https://github.com/simplybusiness/packer/'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://gemstash.simplybusiness.io'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 5'
  spec.add_dependency 'rack-proxy', '~> 0.6.4'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
end
