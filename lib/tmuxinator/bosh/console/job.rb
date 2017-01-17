# frozen_string_literal: true
module Tmuxinator
  module BOSH
    module Console
      Job = Struct.new(:name, :index) do
        def to_s
          "#{name}/#{index}"
        end
      end
    end
  end
end
