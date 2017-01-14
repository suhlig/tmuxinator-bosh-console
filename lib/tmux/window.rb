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

    def split(options={})
      @commands << [
        'split-window',
        background,
        orientation(options),
        size(options),
        "-t #{target}".strip,
      ].compact.join(' ')

      if options[:shell_command]
        @commands << "send-keys -t #{target(1)} '#{options[:shell_command]}' C-m".strip
      end
    end

    private

    def target(pane=0)
      if session
        "#{session.name}:#{name}.#{pane}"
      else
        "#{name}.#{pane}"
      end
    end

    def orientation(options)
      orientation = options[:orientation].to_s
      return nil if orientation.empty?
      mnemonic = orientation.chars.first
      raise "Unknown orientation '#{orientation}'" unless %w(h v).include?(mnemonic)
      "-#{mnemonic}"
    end

    def size(options)
      "-l #{options[:size]}" if options[:size]
    end

    def background
      '-d'
    end
  end
end
