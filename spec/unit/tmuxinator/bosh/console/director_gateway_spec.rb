# frozen_string_literal: true
require 'spec_helper'
require 'tmuxinator/bosh/console/director_gateway'
require 'pathname'

RSpec.describe Tmuxinator::BOSH::Console::DirectorGateway do
  subject(:instances) { Tmuxinator::BOSH::Console::DirectorGateway.new(report).instances }
  let(:report) { (Pathname(__dir__).parent.parent.parent.parent / 'fixtures/instances/cf-warden.txt').read }

  context 'without a filter' do
    it 'has the expected number of instances' do
      expect(instances).to be
      expect(instances.size).to eq(13)
    end

    it 'has all instances' do
      %w( api_z1 blobstore_z1 consul_z1 doppler_z1 etcd_z1 ha_proxy_z1 hm9000_z1
          loggregator_trafficcontroller_z1 nats_z1 postgres_z1 router_z1
          runner_z1 uaa_z1).each do |name|
        expect(instances.map(&:name)).to include(name)
      end
    end
  end

  context 'with a filter' do
    subject(:instances) { Tmuxinator::BOSH::Console::DirectorGateway.new(report).instances(filter) }

    context 'that is empty' do
      let(:filter) { {} }

      it 'has all instances' do
        %w( api_z1 blobstore_z1 consul_z1 doppler_z1 etcd_z1 ha_proxy_z1 hm9000_z1
            loggregator_trafficcontroller_z1 nats_z1 postgres_z1 router_z1
            runner_z1 uaa_z1).each do |name|
          expect(instances.map(&:name)).to include(name)
        end
      end
    end

    context 'that has a single include statement' do
      let(:filter) { { include: /^a/ } }

      it 'has only the instances matching the filter' do
        expect(instances.map(&:name)).to eq(['api_z1'])
      end
    end

    context 'that has a single exclude statement' do
      let(:filter) { { exclude: /^hm/ } }

      it 'has all but the instance matching the filter' do
        instance_names = instances.map(&:name)

        %w( api_z1 blobstore_z1 consul_z1 doppler_z1 etcd_z1 ha_proxy_z1
            loggregator_trafficcontroller_z1 nats_z1 postgres_z1 router_z1
            runner_z1 uaa_z1).each do |name|
          expect(instance_names).to include(name)
        end

        expect(instance_names).to_not include('hm9000_z1')
      end
    end
  end
end
