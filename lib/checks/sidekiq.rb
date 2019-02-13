module Rack
  class HealthCheck
    module Check
      class SidekiqCheck
        def result
          begin
            if defined?(::Sidekiq)
              response = Sidekiq.redis { |connection| connection.info }
              status = response ? Status::OK : Status::ERROR
              value = response['redis_version']
            else
              status = Status::ERROR
              value = 'Sidekiq not defined'
            end
          rescue => e
            status = Status::ERROR
            value = e.message
          end
          { sidekiq: { status: status, value: value.to_s} }
        end
        CheckRegistry.instance.register(:sidekiq, SidekiqCheck)
      end
    end
  end
end
