require "packer/configuration"

namespace :packer do
  desc "Remove the webpack compiled output directory"
  task clobber: ["packer:verify_install", :environment] do
    Packer.clobber
    $stdout.puts "Removed webpack output path directory #{Packer.config.public_output_path}"
  end
end

# Run clobber if the assets:clobber is run
if Rake::Task.task_defined?("assets:clobber")
  Rake::Task["assets:clobber"].enhance do
    Rake::Task["packer:clobber"].invoke
  end
end
