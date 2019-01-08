module Rack
  class HealthCheck
    module Check
      class RedisConnectionCheck
        def result
          value = nil
          begin
            if defined?(::Redis)
              value = ::Redis.current.connected?
              status = value ? Status::OK : Status::ERROR
            else
              status = Status::ERROR
              value = 'Redis connection not found'
            end
          rescue => e
            status = Status::ERROR
            value = e.message
          end
          { redis: { status: status, value: value.to_s } }
        end
        CheckRegistry.instance.register(:redis, RedisConnectionCheck)
      end
    end
  end
end
