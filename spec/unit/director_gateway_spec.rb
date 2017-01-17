# frozen_string_literal: true
require 'spec_helper'
require 'pathname'

RSpec.describe Tmuxinator::BOSH::Console::DirectorGateway do
  subject(:instances) { Tmuxinator::BOSH::Console::DirectorGateway.new(report).instances }
  let(:report) { (Pathname(__dir__).parent / 'fixtures/instances/cf-warden.txt').read }

  it 'has the expected number of instances' do
    expect(instances).to be
    expect(instances.size).to eq(13)
  end

  it 'has the expected instances' do
    %w( api_z1 blobstore_z1 consul_z1 doppler_z1 etcd_z1 ha_proxy_z1 hm9000_z1
        loggregator_trafficcontroller_z1 nats_z1 postgres_z1 router_z1
        runner_z1 uaa_z1).each do |name|
      expect(instances.map { |j| j[:job] }).to include(name)
    end
  end
end
