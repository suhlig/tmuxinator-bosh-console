# frozen_string_literal: true
require 'tmuxinator/bosh/console/job'

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
            Job.new(md['job'], md['index']) if md
          }.compact
        end
      end
    end
  end
end
