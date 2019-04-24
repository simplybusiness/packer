# frozen_string_literal: true

require 'open3'
require 'digest/sha1'

module Packer
  class Compiler
    delegate :logger, :config, to: :@packer

    def initialize(packer)
      @packer = packer
    end

    def compile
      if stale?
        record_compilation_digest
        run_webpack.tap do |success|
          remove_compilation_digest unless success
        end
      else
        true
      end
    end

    # Returns true if all the compiled packs are up to date with the underlying asset files.
    def fresh?
      watched_files_digest == last_compilation_digest
    end

    # Returns true if the compiled packs are out of date with the underlying asset files.
    def stale?
      !fresh?
    end

    private

    def last_compilation_digest
      compilation_digest_path.read if compilation_digest_path.exist? && manifest_path.exist?
    end

    def watched_files_digest
      files = Dir[*watched_paths].reject { |f| File.directory?(f) }
      Digest::SHA1.hexdigest(files.map { |f| "#{File.basename(f)}/#{File.mtime(f).utc.to_i}" }.join('/'))
    end

    def record_compilation_digest
      config.cache_path.mkpath
      compilation_digest_path.write(watched_files_digest)
    end

    def remove_compilation_digest
      compilation_digest_path.delete if compilation_digest_path.exist?
    rescue Errno::ENOENT, Errno::ENOTDIR
    end

    # rubocop:disable Metrics/AbcSize
    def run_webpack
      logger.info 'Compiling…'
      logger.info "ENV: #{webpack_env}"

      sterr, stdout, status = Open3.capture3(webpack_env, 'yarn run webpack')

      if status.success?
        logger.info "Compiled all packs in #{config.public_output_path}"
      else
        logger.error "Compilation failed:\n#{sterr}\n#{stdout}"
      end

      status.success?
    end
    # rubocop:enable Metrics/AbcSize

    def watched_paths
      default_watched_paths + config.watched_paths
    end

    def default_watched_paths
      [
        "#{config.source_path}/**/*",
        'package-lock.json', 'package.json', 'webpack.config.js'
      ].freeze
    end

    def manifest_path
      config.public_manifest_path
    end

    def compilation_digest_path
      config.cache_path.join(".last-compilation-digest-#{Packer.env}")
    end

    def webpack_env
      {
        'NODE_ENV' => @packer.env,
        'PACKER_CONFIG_PATH' => @packer.config_path.to_s
      }
    end
  end
end
