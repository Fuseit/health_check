module Rack
  class HealthCheck
    module Check
      class ActiveRecordConnectionCheck
        def result
          value = nil
          begin
            if defined?(ActiveRecord)
              value = ::ActiveRecord::Base.connection.active?
              status = value ? Status::OK : Status::ERROR
            else
              status = Status::ERROR
              value = 'ActiveRecord connection not found'
            end
          rescue => e
            status = Status::ERROR
            value = e.message
          end
          { active_record: { status: status, value: value.to_s } }
        end
        CheckRegistry.instance.register(:active_record, ActiveRecordConnectionCheck)
      end
    end
  end
end
