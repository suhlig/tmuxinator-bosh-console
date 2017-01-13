# frozen_string_literal: true
require 'tmux/window'

module TMux
  class Session
    attr_reader :name
    attr_accessor :client

    def initialize(name, initial_window_name)
      @name = name
      @commands = []
      @windows = []

      add_window(initial_window_name)
    end

    def create_window(window_name, shell_command=nil)
      @commands << "new-window -d -t #{name}: -n #{window_name} #{shell_command}".strip
      add_window(window_name)
    end

    def window(name)
      @windows.select { |w| name == w.name }.first
    end

    def commands
      (@commands + @windows.collect(&:commands)).flatten
    end

    private

    def add_window(name)
      Window.new(name).tap do |window|
        window.session = self
        @windows << window
      end
    end
  end
end
