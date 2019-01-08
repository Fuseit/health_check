require 'status'

module Rack
  class HealthCheck
    class CheckFactory
      def initialize(definitions, default_checks = [])
        definitions = Array(definitions) | default_checks
        @checks = definitions.map do |check_name, check_parameters|
          {
            class: CheckRegistry.lookup(check_name),
            paramaters: check_parameters 
          }
        end
      end

      def build_all
        @checks.map do |check_definition|
          build(check_definition[:class], check_definition[:paramaters])
        end
      end

      def build(check_class, parameters = nil)
        parameters.nil? ? check_class.new : check_class.new(parameters)
      end
    end
  end
end
