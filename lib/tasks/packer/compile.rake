$stdout.sync = true

def ensure_log_goes_to_stdout
  old_logger = Packer.logger
  Packer.logger = ActiveSupport::Logger.new(STDOUT)
  yield
ensure
  Packer.logger = old_logger
end

def enhance_assets_precompile
  Rake::Task["assets:precompile"].enhance do
    Rake::Task["packer:compile"].invoke
  end
end

namespace :packer do
  desc "Compile JavaScript packs using webpack for production with digests"
  task compile: ["packer:verify_install", :environment] do
    Packer.with_node_env("production") do
      ensure_log_goes_to_stdout do
        exit! unless Packer.compile
      end
    end
  end
end

# Compile packs after we've compiled all other assets during precompilation
if Rake::Task.task_defined?("assets:precompile")
  skip_webpacker_precompile = %w(no false n f).include?(ENV["PACKER_PRECOMPILE"])
  enhance_assets_precompile unless skip_webpacker_precompile
else
  Rake::Task.define_task("assets:precompile" => ["packer:compile"])
end
