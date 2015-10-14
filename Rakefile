require "bundler/gem_tasks"


task :spec do
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec)
  rescue LoadError
  end
end
