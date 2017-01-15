# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tmuxinator/bosh/console/version'

Gem::Specification.new do |spec|
  spec.name          = 'tmuxinator-bosh-console'
  spec.version       = Tmuxinator::BOSH::Console::VERSION
  spec.authors       = ['Steffen Uhlig']
  spec.email         = ['Steffen.Uhlig@de.ibm.com']

  spec.summary       = 'Generates the tmuxinator configuration for all VMs of a BOSH deployment'
  spec.description   = "#{spec.summary}. Each instance (VM) will get its own tmux window with some panes, according to the provided template."
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bosh_cli'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rb-readline'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
