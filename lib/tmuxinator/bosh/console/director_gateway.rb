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

        def instances(filter={})
          @report.lines.map { |line|
            md = line.match(%r{\| (?<job>\w+)\/(?<index>\d+)})
            Job.new(md['job'], md['index']) if md
          }.compact.tap do |result|
            result.select! { |job| filter[:include].match(job.name) } if filter[:include]
            result.reject! { |job| filter[:exclude].match(job.name) } if filter[:exclude]
          end
        end
      end
    end
  end
end
