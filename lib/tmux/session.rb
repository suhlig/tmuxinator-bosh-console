# frozen_string_literal: true
require 'tmux/window'

module TMux
  class Session
    attr_reader :name
    attr_accessor :client

    def initialize(name)
      @name = name
      @windows = []
      @commands = []
    end

    def create_window(window_name, shell_command=nil)
      @commands << "new-window -d -t #{name}: -n #{window_name} #{shell_command}".strip
      Window.new(window_name).tap do |window|
        window.session = self
        @windows << window
      end
    end

    def window(name)
      @windows.select { |w| name == w.name }.first
    end

    def commands
      (@commands + @windows.collect(&:commands)).flatten
    end
  end
end
