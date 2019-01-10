module Rack
  class HealthCheck
    module Check
      class HTTPStatus
        def result
          { http: { status: Status::OK } }
        end
      end
      CheckRegistry.instance.register(:http, HTTPStatus)
    end
  end
end
