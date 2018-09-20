# frozen_string_literal: true

require 'open3'
require 'digest/sha1'

module Packer
  class Installer
    delegate :logger, :config, to: :@packer

    def initialize(packer)
      @packer = packer
    end

    def install
      return true if fresh?

      record_package_digest
      run_npm_install.tap do |success|
        remove_package_digest unless success
      end
    end

    def fresh?
      package_file_digest == last_package_digest
    end

    def stale?
      !fresh?
    end

    private

    def last_package_digest
      package_digest_path.read if package_digest_path.exist?
    end

    def package_file_digest
      contents = package_lock_path.exist? ? package_lock_path.read : ''
      Digest::SHA1.hexdigest(contents)
    end

    def record_package_digest
      config.cache_path.mkpath
      package_digest_path.write(package_file_digest)
    end

    def remove_package_digest
      logger.info 'Calling'
      package_digest_path.delete if package_digest_path.exist?
    rescue Errno::ENOENT, Errno::ENOTDIR
    end

    def run_npm_install
      logger.info 'Installing latest NPM packages (this may take a while)…'
      sterr, stdout, status = Open3.capture3('npm install')

      if status.success?
        logger.info 'Successfully installed packages'
      else
        logger.error "Installation failed:\n#{sterr}\n#{stdout}"
      end
    end

    def package_lock_path
      Pathname('package-lock.json')
    end

    def package_digest_path
      config.cache_path.join(".last-package-digest-#{Packer.env}")
    end
  end
end
