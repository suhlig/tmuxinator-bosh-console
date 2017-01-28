# frozen_string_literal: true
require 'spec_helper'
require 'tmuxinator/bosh/console/template'
require 'yaml'

RSpec.describe Tmuxinator::BOSH::Console::Template do
  subject(:template) { Tmuxinator::BOSH::Console::Template.new(template_source) }
  let(:template_source) { instance_double(IO) }

  it 'can be constructed with an IO object' do
    allow(template_source).to receive(:read)
    expect(template).to be
  end

  it 'renders a template without expressions' do
    allow(template_source).to receive(:read).and_return 'foo bar'
    expect(template.render(binding)).to eq('foo bar')
  end

  it 'renders a template with an expression' do
    bar = 'baz'
    allow(template_source).to receive(:read).and_return 'foo <%= bar %>'
    expect(template.render(binding)).to eq('foo baz')
  end

  context 'using the default template' do
    let(:project_name) { 'test' }
    let(:additional_args) { [] }
    let(:instances) { [] }
    let(:template_source) {
      (Pathname(__dir__).parent.parent.parent.parent.parent / 'templates/bosh-console.yml')
    }
    let(:result) { YAML.safe_load(template.render(binding)) }

    context 'no instances' do
      it 'produces valid YAML' do
        expect { result }.to_not raise_error
      end

      it 'renders the project name' do
        expect(result['name']).to eq('test')
      end

      it 'renders no windows' do
        expect(result['windows']).to be_nil
      end
    end

    context 'one instance' do
      let(:job_0) {
        double.tap { |d|
          allow(d).to receive(:name).and_return('job')
          allow(d).to receive(:index).and_return(0)
        }
      }

      before do
        instances << job_0
      end

      it 'renders one window' do
        expect(result['windows']).to_not be_empty
        expect(result['windows'].size).to eq(1)
      end

      it 'renders the window name' do
        expect(result['windows']).to_not be_empty
        expect(result['windows'].first.keys.first).to eq('job/0')
      end

      it 'has a bosh ssh command' do
        expect(result['windows'].first['job/0']['pre']).to eq 'bosh ssh job/0'
      end

      context 'additional arguments' do
        let(:additional_args) { %w(foo --bar foobar) }

        it 'appends the arguments to bosh ssh' do
          expect(result['windows'].first['job/0']['pre']).to eq 'bosh ssh job/0 foo --bar foobar'
        end
      end
    end

    context 'multiple instances' do
      let(:job_0) {
        double.tap { |d|
          allow(d).to receive(:name).and_return('job')
          allow(d).to receive(:index).and_return(0)
        }
      }

      let(:job_1) {
        double.tap { |d|
          allow(d).to receive(:name).and_return('job')
          allow(d).to receive(:index).and_return(1)
        }
      }

      before do
        instances << job_0
        instances << job_1
      end

      it 'renders two windows' do
        expect(result['windows']).to_not be_empty
        expect(result['windows'].size).to eq(2)
      end

      it 'renders the window names' do
        expect(result['windows']).to_not be_empty
        expect(result['windows'].size).to eq(2)
        expect(result['windows'].first.keys.first).to eq('job/0')
        expect(result['windows'].last.keys.first).to eq('job/1')
      end
    end
  end
end
