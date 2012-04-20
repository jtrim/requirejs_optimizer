#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run all unit tests"
RSpec::Core::RakeTask.new("spec:unit") do |t|
  t.rspec_opts = %w[--color]
  t.pattern = "spec/lib/**/*_spec.rb"
end

desc "Run all integration tests"
RSpec::Core::RakeTask.new("spec:integration") do |t|
  t.rspec_opts = %w[--color]
  t.pattern = "spec/integrations/**/*_spec.rb"
end

task :default => ["spec:unit", "spec:integration"]
