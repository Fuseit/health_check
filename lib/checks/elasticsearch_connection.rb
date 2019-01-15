module Rack
  class HealthCheck
    module Check
      class ElasticsearchConnectionCheck
        attr_reader :server_url
        PATH = '_cluster/health'.freeze
        SUCCESS_STATUSES = %w[yellow green].freeze

        def initialize(parameters = {})
          @server_url = parameters[:server_url]
        end

        def result
          begin
            value = @server_url ? connect(@server_url) : 'Server URL not found'
            status = if SUCCESS_STATUSES.include?(value)
                       Status::OK
                     else
                       Status::ERROR
                     end
          rescue => e
            status = Status::ERROR
            value = e.message
          end
          { elasticsearch: { status: status, value: value.to_s} }
        end

        def connect(url)
          if defined?(Elasticsearch::Client)
            client = Elasticsearch::Client.new(url: url)
            response = client.perform_request 'GET', PATH
            response.body['status']
          else
            'Elasticsearch API not found'
          end
        end
        CheckRegistry.instance.register(:elasticsearch, ElasticsearchConnectionCheck)
      end
    end
  end
end
