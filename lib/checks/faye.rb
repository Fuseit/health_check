require 'net/http'
require 'uri'

module Rack
  class HealthCheck
    module Check
      class FayeConnectionCheck
        attr_reader :server_url

        def initialize(parameters = {})
          @server_url = parameters[:server_url]
        end

        def result
          begin
            value = @server_url ? connect(@server_url) : 'Server URL not found'
            status = value ? Status::OK : Status::ERROR
          rescue => e
            status = Status::ERROR
            value = e.message
          end
          { faye: { status: status, value: value.to_s} }
        end

        def connect(server_url)
          url = URI.parse(server_url)
          connection = Net::HTTP.new(url.host, url.port)
          connection.start
          result = connection.started?
          connection.finish
          result
        end
        CheckRegistry.instance.register(:faye, FayeConnectionCheck)
      end
    end
  end
end
