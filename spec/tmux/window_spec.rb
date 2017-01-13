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
      expect(window.commands).to include("send-keys -t test-window 'command_a' C-m")
    end

    it 'produces send-keys commands for all typed commands' do
      window.type('command_a', 'command_b')
      expect(window.commands).to include("send-keys -t test-window 'command_a' C-m")
      expect(window.commands).to include("send-keys -t test-window 'command_b' C-m")
    end
  end

  context 'with an owning session' do
    let(:session) { instance_double('TMux::Session') }

    before do
      window.session = session
    end

    it 'targets the session of the given window' do
      allow(session).to receive(:name).and_return('test-session')
      window.type('command_b')
      expect(window.commands).to include("send-keys -t test-session:test-window 'command_b' C-m")
    end
  end
end
