require 'rest-client'
require 'openssl'

module BOSH
  class Director
    def initialize(url, user, password, options={})
      ssl_verification = OpenSSL::SSL.const_get("VERIFY_#{options[:verify_ssl].upcase}")
      @remote = RestClient::Resource.new(url,
                                         user: user,
                                         password: password,
                                         verify_ssl: ssl_verification)
    end

    def vms(deployment)
      JSON.parse(@remote["deployments/#{deployment}/vms"].get).
        sort_by { |vm| [vm['job'], vm['index']] }
    end
  end
end
