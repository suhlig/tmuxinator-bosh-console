# frozen_string_literal: true
require 'spec_helper'
require 'tmux/client'

RSpec.describe TMux::Client do
  subject(:client) { TMux::Client.new }

  it 'starts with no commands' do
    expect(client.commands).to be_empty
  end

  context 'with create_session' do
    let(:session) { client.create_session('test-session', 'window-name') }

    it 'produces a new-session command' do
      expect(session).to be
      expect(client.commands).to include('new-session -d -s test-session -n window-name')
    end

    it 'includes the commands of the windows' do
      session.create_window('test')
      expect(client.commands).to include('new-window -d -t test-session: -n test')
    end
  end
end
