# frozen_string_literal: true
require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'bundler/gem_tasks'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

namespace :spec do
  desc 'Run ci tests'
  task ci: ['rubocop', :spec]
end

task default: ['rubocop:auto_correct', :spec]
