tasks = {
  "packer:info"                    => "Provides information on Packer's environment",
  "packer:install"                 => "Installs NPM packages",
  "packer:compile"                 => "Compiles webpack bundles based on environment",
  "packer:clobber"                 => "Removes the webpack compiled output directory",
  "packer:verify_install"          => "Verifies if Packer is installed"
}.freeze

desc "Lists all available tasks in Packer"
task :packer do
  puts "Available Packer tasks are:"
  tasks.each { |task, message| puts task.ljust(30) + message }
end
