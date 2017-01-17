# frozen_string_literal: true
require 'erb'

module Tmuxinator
  module BOSH
    module Console
      class Template
        def initialize(io)
          @content = io.read
        end

        def render(source_binding)
          ERB.new(@content).result(source_binding)
        end
      end
    end
  end
end
