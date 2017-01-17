# frozen_string_literal: true
require 'spec_helper'
require 'pathname'

RSpec.describe Tmuxinator::BOSH::Console::DirectorGateway do
  subject(:gateway) { Tmuxinator::BOSH::Console::DirectorGateway.new(report) }
  let(:report) { (Pathname(__dir__).parent / 'fixtures/instances/cf-warden.txt').read }

  it 'has three instances' do
    expect(gateway.instances).to be
    expect(gateway.instances.size).to eq(13)
  end
end
