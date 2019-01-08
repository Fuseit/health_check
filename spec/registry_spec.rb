RSpec.describe Rack::HealthCheck::CheckRegistry do
  class MyCheckClass; end
  subject(:check_registry) { described_class }

  before do
    check_registry.register(:my_check, MyCheckClass)
  end

  describe 'Look up a class name' do
    context 'with a registered class' do
      it 'returns the registered class' do
        expect(check_registry.lookup(:my_check)).to eq(MyCheckClass)
      end
    end

    context 'when the class is not registered' do
      it 'raises an error' do
        expect { check_registry.lookup(:my_other_check) }.to raise_error(
          Rack::HealthCheck::CheckRegistry::CheckNotRegisteredError
        )
      end
    end
  end
end
