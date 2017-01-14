# frozen_string_literal: true
require 'spec_helper'
require 'tmux/session'

RSpec.describe TMux::Window do
  subject(:window) { TMux::Window.new(name) }
  let(:name) { 'test-window' }

  it 'starts with no commands' do
    expect(window.commands).to be_empty
  end

  context 'without an owning session' do
    it 'produces a send-keys command when typing a single command' do
      window.type('command_a')
      expect(window.commands).to include("send-keys -t test-window.0 'command_a' C-m")
    end

    it 'produces send-keys commands for all typed commands' do
      window.type('command_a', 'command_b')
      expect(window.commands).to include("send-keys -t test-window.0 'command_a' C-m")
      expect(window.commands).to include("send-keys -t test-window.0 'command_b' C-m")
    end

    it 'can split off a new pane' do
      pane = window.split
      expect(window.commands).to include('split-window -d -t test-window.0')
      expect(pane).to respond_to(:type)
    end

    it 'can split off a new pane with a specifically horizontal orientation' do
      window.split(orientation: :horizontal)
      expect(window.commands).to include('split-window -d -h -t test-window.0')
    end

    it 'can split off a new pane with a specifically vertical orientation' do
      window.split(orientation: :vertical)
      expect(window.commands).to include('split-window -d -v -t test-window.0')
    end

    it 'does not accept an unknown orientation' do
      expect { window.split(orientation: :unknown) }.to raise_error /Unknown orientation/
    end

    it 'can split off a pane with a specific size' do
      window.split(size: 42)
      expect(window.commands).to include('split-window -d -l 42 -t test-window.0')
    end

    it 'can split off a new pane with a command' do
      window.split(shell_command: 'ls')
      expect(window.commands).to include('split-window -d -t test-window.0')
      expect(window.commands).to include("send-keys -t test-window.1 'ls' C-m")
    end
  end

  context 'with an owning session' do
    let(:session) { instance_double('TMux::Session') }

    before do
      window.session = session
      allow(session).to receive(:name).and_return('test-session')
    end

    it 'targets the session of the given window' do
      window.type('command_b')
      expect(window.commands).to include("send-keys -t test-session:test-window.0 'command_b' C-m")
    end

    it 'splits a new pane in the owning session' do
      window.split
      expect(window.commands).to include('split-window -d -t test-session:test-window.0')
    end
  end
end
