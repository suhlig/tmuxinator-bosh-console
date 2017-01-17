# frozen_string_literal: true
module Tmuxinator
  module BOSH
    module Console
      #
      # Gateway to the BOSH director
      #
      class DirectorGateway
        def initialize(report=`bosh instances`)
          @report = report
        end

        def instances
          @report.lines.map { |line|
            md = line.match(%r{\| (?<job>\w+)\/(?<index>\d+)})

            if md
              {
                job: md['job'],
                index: md['index'],
              }
            end
          }.compact
        end
      end
    end
  end
end
