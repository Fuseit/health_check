require 'check_registry'
require 'checks/http_status'
require 'checks/active_record_connection'
require 'checks/redis_connection'

module Rack
  class HealthCheck
    module Check
      module Status
        OK = 'OK'.freeze
        ERROR = 'ERROR'.freeze
      end
    end
  end
end
