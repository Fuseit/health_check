require 'json'
require 'check_factory'

module Rack
  class HealthCheck
    OK = 200
    SERVER_ERROR = 500
    NOT_FOUND = 404

    def initialize(app=nil, options={})
      @app = app
      check_configuration = options.delete(:checks) || []
      @check_factory = CheckFactory.new(check_configuration, [:http])
    end

    def call(env)
      if env['PATH_INFO'] == '/health'
        check_results = @check_factory.build_all.inject({}) do |results, check|
          results.merge(check.result)
        end
        success = check_results.none? { |check| check[1][:status] == Check::Status::ERROR }
        response_status = success ? OK : SERVER_ERROR
        response_headers = {'Content-Type' => 'application/json'}
        response_body = JSON.pretty_generate(check_results)
        @app.logger.info response_body if @app
        [response_status, response_headers, [response_body]]

      elsif @app
        @app.call(env)
      else
        [NOT_FOUND, {}, []]
      end
    end
  end
end
