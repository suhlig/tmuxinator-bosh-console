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
    let(:instances) { [] }
    let(:template_source) {
      (Pathname(__dir__).parent.parent.parent.parent / 'templates/bosh-console.yml')
    }

    context 'no instances' do
      let(:result) { template.render(binding) }
      it 'produces valid YAML' do
        expect { YAML.load(result) }.to_not raise_error
      end

      it 'renders the project name' do
        expect(YAML.load(result)['name']).to eq('test')
      end

      it 'renders no windows' do
        expect(YAML.load(result)['windows']).to be_nil
      end
    end
  end
end
