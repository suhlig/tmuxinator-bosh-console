# frozen_string_literal: true
require 'spec_helper'
require 'tmux/session'

RSpec.describe TMux::Session do
  subject(:session) { TMux::Session.new(name) }
  let(:name) { 'test-session' }

  it 'starts with no commands' do
    expect(session.commands).to be_empty
  end

  context 'with create_window' do
    it 'produces a new-window command' do
      session.create_window('test')

      commands = session.commands
      expect(commands).to include('new-window -d -t test-session: -n test')
    end
  end
end
