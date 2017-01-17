# frozen_string_literal: true
guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  watch('Gemfile')
  watch(/^.*\.gemspec/)
end

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+/.+)\.rb$}) { |m| "spec/unit/#{m[1]}_spec.rb" }
end
