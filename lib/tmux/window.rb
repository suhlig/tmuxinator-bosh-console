# frozen_string_literal: true
require 'tmux/pane'

module TMux
  class Window
    attr_reader :name
    attr_accessor :session

    def initialize(name)
      @name = name
      @commands = []
      @panes = []
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

      # send the command to the new pane
      pane_id = 1

      if options[:shell_command]
        @commands << "send-keys -t #{target(pane_id)} '#{options[:shell_command]}' C-m".strip
      end

      Pane.new(pane_id).tap do |pane|
        pane.window = self
        @panes << pane
      end
    end

    def commands
      (@commands + @panes.collect(&:commands)).flatten
    end

    # TODO: Managing the pane id here is odd. We should delegate this to the Pane.
    # We probably need to model the default pane here, anyway.
    def target(pane=0)
      if session
        "#{session.name}:#{name}.#{pane}"
      else
        "#{name}.#{pane}"
      end
    end

    private

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
