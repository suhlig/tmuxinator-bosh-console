# frozen_string_literal: true
require 'spec_helper'
require 'tmuxinator/bosh/console/template'

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
end
