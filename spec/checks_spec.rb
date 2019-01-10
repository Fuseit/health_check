RSpec.describe 'when used as middleware' do
  let(:app) {
    opts = options
    Rack::Builder.new do
      use Rack::HealthCheck, opts
      run lambda {|env|
        if env['PATH_INFO'] == '/hello/world'
          [200, {}, ['Hello, World']]
        else
          [404, {}, ['Goodbye, World']]
        end
      }
    end
  }
  let(:options) { {} }

  context 'main app' do
    it 'responds OK for normal requests' do
      get '/hello/world'
      expect(last_response).to be_ok
    end
  end

  context 'health check response passes' do
    it 'responds ' do
      get '/health'
      expect(last_response).to be_ok
    end

    context 'when all checks pass' do
      it 'has a success error code' do
        get '/health'
        expect(last_response.status).to eq(200)
      end
    end

    context 'active_record connection check' do
      let(:options) { { checks: [:active_record] } }
      context 'when available' do
        let(:active) { true }
        let(:connection) { double('connection') }
        it 'is reported' do
          allow(ActiveRecord::Base).to receive(:connection).and_return(connection)
          allow(connection).to receive(:active?).and_return(active)
          get '/health'
          expect(json_body['active_record']['status']).to eq('OK')
          expect(json_body['active_record']['value']).to eq(active.to_s)
        end
      end

      context 'when not available' do
        it 'is reported' do
          Object.send(:remove_const, :ActiveRecord) if defined?(ActiveRecord)
          get '/health'
          expect(json_body['active_record']['status']).to eq('ERROR')
          expect(json_body['active_record']['value']).to eq('ActiveRecord connection not found')
        end
      end
    end

    context 'redis' do
      let(:options) { { checks: [:redis] } }
      context 'when available' do
        let(:instance) { double('current') }
        let(:connected) { true }
        it 'is reported' do
          allow(Redis).to receive(:current).and_return(instance)
          allow(instance).to receive(:connected?).and_return(connected)
          get '/health'
          expect(json_body['redis']['status']).to eq('OK')
          expect(json_body['redis']['value']).to eq(connected.to_s)
        end
      end

      context 'when not available' do
        it 'is reported' do
          Object.send(:remove_const, :Redis) if defined?(Redis)
          get '/health'
          expect(json_body['redis']['status']).to eq('ERROR')
          expect(json_body['redis']['value']).to eq('Redis connection not found')
        end
      end
    end
  end
end
