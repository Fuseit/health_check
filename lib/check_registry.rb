require 'singleton'

module Rack
  class HealthCheck
    class CheckRegistry
      include Singleton
      class CheckNotRegisteredError < ::StandardError
      end

      def initialize
        @registry = {}
      end

      def self.lookup(name)
        instance.lookup(name)
      end

      def self.register(name, check_class)
        instance.register(name, check_class)
      end

      def register(name, check_class)
        @registry[name] = check_class
      end

      def lookup(name)
        @registry.fetch(name) { raise CheckNotRegisteredError.new("Check '#{name}' is not registered") }
      end
    end
  end
end
