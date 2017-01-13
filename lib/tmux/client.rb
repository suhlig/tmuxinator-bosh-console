# frozen_string_literal: true
require 'open3'
require 'tmux/session'

module TMux
  class Client
    def initialize
      @commands = []
      @sessions = []
    end

    def session?(name)
      Open3.popen3("tmux has-session -t #{name}") do |_, _, _, thread|
        return thread.value.success?
      end
    end

    def create_session(session_name, window_name, shell_command=nil)
      @commands << "new-session -d -s #{session_name} -n #{window_name} #{shell_command}".strip
      Session.new(session_name).tap do |session|
        @sessions << session
        session.client = self
      end
    end

    def switch(session_name)
      @commands << "switch-client -t #{session_name}"
    end

    def commands
      (@commands + @sessions.collect(&:commands)).flatten
    end
  end
end
