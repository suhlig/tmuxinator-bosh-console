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
      # Do not send the shell command as initial command, because this would
      # make the whole session disappear if that first command fails.
      @commands << "new-session -d -s #{session_name} -n #{window_name}".strip
      @commands << "send-keys -t #{session_name}:#{window_name} '#{shell_command}' C-m".strip

      Session.new(session_name, window_name).tap do |session|
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
