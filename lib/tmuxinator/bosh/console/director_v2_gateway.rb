# frozen_string_literal: true
require 'tmuxinator/bosh/console/job'

# Compatibility with [v2 of the bosh cli](https://bosh.io/docs/cli-v2.html):
#
# ```bash
# bosh \
#     -e https://192.168.50.4:25555 \
#     --ca-cert=~/workspace/bosh-lite/ca/certs/a.crt \
#     -d cf-warden \
#   instances \
#     --json
# ```
#
# Potentially, we simply map a bosh environment name to a tmuxinator project; e.g. after creating an env with
#
# ```bash
# bosh --ca-cert=~/workspace/bosh-lite/ca/certs/ca.crt -e https://192.168.50.4:25555 alias-env lite
# ```
#
# we can refer to it as `lite`:
#
# ```bash
# bosh -e lite -d cf-warden vms --json
# ```
module Tmuxinator
  module BOSH
    module Console
      #
      # Gateway to a v2 BOSH director
      #
      class DirectorGateway
      end
    end
  end
end
