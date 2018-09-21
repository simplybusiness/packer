namespace :packer do
  desc 'Install NPM packages required for Packer asset compilation'
  task :install do
    $stdout.print 'Installing NPM packages… '
    system('npm install --quiet --no-progress')
  end
end
