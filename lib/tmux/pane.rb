# frozen_string_literal: true
module TMux
  class Pane
    attr_reader :id, :commands
    attr_accessor :window

    def initialize(id)
      @id = id
      @commands = []
    end

    def type(*commands)
      commands.each do |command|
        @commands << "send-keys -t #{target} '#{command}' C-m".strip
      end
    end

    private

    def target
      if window
        window.target
      else
        ".#{id}"
      end
    end
  end
end
