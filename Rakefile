require 'rake'
require 'puppet-lint/tasks/puppet-lint'
require 'rspec/core/rake_task'

PuppetLint.configuration.send('disable_autoloader_layout')

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

task :default => [:spec, :lint]
