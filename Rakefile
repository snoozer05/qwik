# -*- coding: utf-8 -*-
require 'rake'
require 'rspec/core/rake_task'

task :default => [:spec]

desc 'Run the code in spec'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--color"]
  t.pattern = "spec/**/*_spec.rb"
end
