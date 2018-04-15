class Packer::Commands
  delegate :config, :compiler, :manifest, to: :@packer

  def initialize(packer)
    @packer = packer
  end

  def clobber
    config.public_output_path.rmtree if config.public_output_path.exist?
    config.cache_path.rmtree if config.cache_path.exist?
  end

  def bootstrap
    config.refresh
    manifest.refresh
  end

  def compile
    compiler.compile.tap do |success|
      manifest.refresh if success
    end
  end
end
