# frozen_string_literal: true
require 'tmux/window'

module TMux
  class Window
    attr_reader :name, :commands
    attr_accessor :session

    def initialize(name)
      @name = name
      @commands = []
    end

    def type(*commands)
      commands.each do |command|
        @commands << "send-keys -t #{target} '#{command}' C-m".strip
      end
    end

    private

    def target
      if session
        "#{session.name}:#{name}"
      else
        name
      end
    end
  end
end
