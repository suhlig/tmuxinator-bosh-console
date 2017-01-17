# frozen_string_literal: true
require 'spec_helper'
require 'tmuxinator/bosh/console/job'

RSpec.describe Tmuxinator::BOSH::Console::Job do
  subject(:job) { Tmuxinator::BOSH::Console::Job.new(name, index) }
  let(:name) { 'test-name' }
  let(:index) { 42 }

  it 'has the provided name' do
    expect(job.name).to eq('test-name')
  end

  it 'has the provided index' do
    expect(job.index).to eq(42)
  end

  it 'provides #to_s' do
    expect(job.to_s).to eq('test-name/42')
  end
end
