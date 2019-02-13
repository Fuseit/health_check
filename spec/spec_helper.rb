require 'rspec'
require 'rack/test'
require 'health_check'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  class ActiveRecord
    class Base
    end
  end

  class Redis
  end

  class Sidekiq
  end

  class Elasticsearch
    class Client
    end
  end

  def json_body
    @json_body ||= JSON.parse(last_response.body)
  end
end
